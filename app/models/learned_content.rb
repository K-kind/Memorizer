class LearnedContent < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :related_images, dependent: :destroy
  has_many :related_words, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :user
  belongs_to :word_category
  belongs_to :word_definition
  belongs_to :calendar
  has_rich_text :content
  accepts_nested_attributes_for :questions

  after_create  :set_first_cycle

  validates :content, presence: true, length: { maximum: 3000 }

  scope :to_review_today, -> { where('till_next_review <= 0') }
  scope :to_review_this_day, ->(date) { where('till_next_review = ? AND till_next_review >= 1', (date - Time.zone.today).to_i) }
  scope :till_next_asc, -> { order(till_next_review: 'ASC') }
  scope :latest, -> { order(id: 'DESC') }
  scope :all_or_weekly, ->(weekly) do
    if weekly
      where('created_at >= ?', Time.current.beginning_of_week)
    else
      all
    end
  end

  def create_related_images(related_image_array)
    related_image_array.each_with_index do |related_image, index|
      unless index.zero? # 配列1つ目は空
        image_links = related_image.split(' ') # [0]大画像リンク、[1]サムネリンク、[2]word
        self.related_images.create!(remote_image_url: image_links[0], word: image_links[2])
      end
    end
  end

  def create_related_words(related_word_array)
    self.related_words.destroy_all
    related_word_array.each_with_index do |related_word, index|
      unless index.zero? || self.word_definition.word == related_word
        word_definition_id = WordDefinition.find_by(word: related_word).id
        self.related_words.create!(word_definition_id: word_definition_id)
      end
    end
  end

  def word_array(word)
    array = [word]
    self.related_words.each do |related_word|
      array << related_word.word_definition.word
    end
    array
  end

  # 平均の計算に先立って、各similarityもセットされる
  def average_similarity
    similarity_array = []
    questions.each do |question|
      similarity_array << question.calculate_similarity
    end
    sum_of_similarity = similarity_array.inject(0) { |sum, similarity| sum + similarity }
    sum_of_similarity / similarity_array.length
  end

  def set_next_cycle
    times = review_histories.not_again.count
    if (next_cycle = user.cycles.find_by(times: times).cycle)
      update(till_next_review: next_cycle)
    else
      update(till_next_review: 10000, completed: true)
    end
  end

  def my_favorite?(user)
    favorites.find_by(user_id: user.id).present?
  end

  def filter_valid_questions
    questions.each do |q|
      q.destroy if q.question.blank? && q.answer.blank?
    end
  end

  private

  def set_first_cycle
    first_cycle = user.cycles.find_by(times: 0).cycle
    return if first_cycle == 1

    update!(till_next_review: first_cycle)
  end
end
