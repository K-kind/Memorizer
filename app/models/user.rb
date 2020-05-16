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
    UserMailer.account_activation(self).deliver_now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def send_notification_email(contact = nil)
    NotificationMailer.user_notification(self, contact).deliver_now
  end

  def level_up?(added_exp)
    update(exp: (exp + added_exp))
    return unless Level.find_by!(level: level).threshold <= exp

    update(level: (level + 1))
  end

  def save_consulted_word(word_definition)
    consulted_words.find_or_create_by!(word_definition_id: word_definition.id)
  end

  def set_test_words
    test_admin = User.find_by(email: Rails.application.credentials.dig(:seed, :test_admin_email))
    test_admin.consulted_words.each do |consulted_word|
      consulted_words.find_or_create_by!(word_definition_id: consulted_word.word_definition_id)
    end
    test_admin.later_lists.each do |later_list|
      later_lists.find_or_create_by!(word: later_list.word)
    end
    test_admin.contacts.each do |contact|
      contacts.find_or_create_by!(comment: contact.comment) do |c|
        c.from_admin = contact.from_admin
        c.created_at = contact.created_at
      end
    end
    learn_templates.last.update!(
      content: test_admin.learn_templates.last.content
    )
    unless notifications.where(checked: false).any?
      notifications.destroy_all
      notifications.create!
    end
  end

  def import_content(original_content, calendar_today)
    learned_contents.create!(
      word_definition_id: original_content.word_definition_id,
      word_category_id: original_content.word_category_id,
      calendar_id: calendar_today.id,
      imported_from: original_content.id,
      imported: true,
      is_public: false,
      completed: false,
      content: original_content.content
    )
  end

  def set_calendar_to_review(review_date)
    calendars.find_or_create_by!(calendar_date: review_date)
  end

  def rollback_to_default_cycle
    [1, 7, 16, 35, 62].each_with_index do |cycle, index|
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
    [1, 7, 16, 35, 62].each_with_index do |cycle, index|
      cycles.create!(times: index, cycle: cycle)
    end
  end
end
