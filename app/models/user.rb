class User < ApplicationRecord
  has_many :calendars,        dependent: :destroy
  has_many :consulted_words,  dependent: :destroy
  has_many :contacts,         dependent: :destroy
  has_many :cycles,           dependent: :destroy
  has_many :favorites,        dependent: :destroy
  has_many :later_lists,      dependent: :destroy
  has_many :learned_contents, dependent: :destroy
  has_many :learn_templates,  dependent: :destroy
  has_many :notifications,    dependent: :destroy
  has_many :review_histories, through: :learned_contents
  has_many :passive_favorites, through: :learned_contents, source: :favorites
  belongs_to :user_skill, optional: true
  accepts_nested_attributes_for :cycles

  has_secure_password
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save   :downcase_email, unless: :uid?
  before_create :create_activation_digest
  after_create  :set_default_cycle
  after_create  :set_default_template_ja

  validates :name, presence: true, length: { maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    unless: :uid?,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :user_skill, presence: true, unless: :uid?

  scope :regular, -> { where(is_test_user: false) }

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def find_or_create_from_auth(auth)
      provider = auth[:provider]
      uid = auth[:uid]
      name = auth[:info][:name]

      find_or_create_by!(provider: provider, uid: uid) do |user|
        user.name = name
        user.password = SecureRandom.hex(9) if user.password.nil?
      end
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def send_activation_email
    UserMailer.account_activation(user: self, user_activation_token: activation_token).deliver_later
  end

  def send_password_reset_email
    UserMailer.password_reset(user: self, user_reset_token: reset_token).deliver_later
  end

  def send_notification_email_to_admin(contact = nil)
    NotificationMailer.user_notification_to_admin(user: self, contact: contact).deliver_later
  end

  def level_up?(added_exp)
    update(exp: (exp + added_exp))
    return unless Level.find_by!(level: level).threshold <= exp

    update(level: (level + 1))
  end

  def save_consulted_word(word_definition)
    consulted_words.find_or_create_by!(word_definition_id: word_definition.id)
  end

  def reset_test_words(test_admin)
    if consulted_words.count < test_admin.consulted_words.count
      test_admin.consulted_words.each do |consulted_word|
        consulted_words.find_or_create_by!(word_definition_id: consulted_word.word_definition_id)
      end
    end
    if later_lists.count < test_admin.later_lists.count
      test_admin.later_lists.each do |later_list|
        later_lists.find_or_create_by!(word: later_list.word)
      end
    end
    if learn_templates.last.updated_at > Time.zone.now - 12.hours
      learn_templates.last.update!(
        content: test_admin.learn_templates.last.content
      )
    end
  end

  def reset_test_contacts(test_admin)
    contacts.destroy_all
    test_admin.contacts.each do |contact|
      contacts.create!(
        comment: contact.comment,
        from_admin: contact.from_admin,
        created_at: Time.zone.yesterday
      )
    end
  end

  def reset_test_notification
    return if notifications.where(checked: false, to_admin: false).any?

    notifications.destroy_all
    notifications.create!
  end

  def set_calendar_to_review(review_date)
    calendars.find_or_create_by!(calendar_date: review_date)
  end

  def rollback_to_default_cycle
    Cycle::DEFAULT_CYCLES.each_with_index do |cycle, index|
      new_cycle = cycles.find_by(times: index)
      new_cycle.update!(cycle: cycle)
    end
    cycles.where('times > 4').destroy_all
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def set_default_cycle
    Cycle::DEFAULT_CYCLES.each_with_index do |cycle, index|
      cycles.create!(times: index, cycle: cycle)
    end
  end

  def set_default_template_ja
    learn_templates.create!(
      content: LearnTemplate::DEFAULT_JA
    )
  end
end
