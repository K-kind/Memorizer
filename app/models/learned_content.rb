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

  scope :to_review_today, -> { where('till_next_review <= 0') }
  scope :to_review_this_day, ->(date) { where('till_next_review = ? AND till_next_review >= 1', (date - Time.zone.today).to_i) }
  scope :till_next_asc, -> { order(till_next_review: 'ASC') }
  scope :latest, -> { order(id: 'DESC') }
  scope :all_or_monthly, ->(monthly) do
    if monthly
      where('created_at >= ?', Time.current.beginning_of_month)
    else
      all
    end
  end

  def create_related_images(related_image_array)
    self.related_images.destroy_all
    related_image_array.each_with_index do |related_image, index|
      unless index.zero?
        image_links = related_image.split(' ')
        self.related_images.create!(large_image_link: image_links[0], image_link: image_links[1], word: image_links[2])
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
    case review_histories.not_again.count
    when 1
      update(till_next_review: 7)
    when 2
      update(till_next_review: 16)
    when 3
      update(till_next_review: 35)
    when 4
      update(till_next_review: 62)
    when 5
      update(till_next_review: 10000, completed: true)
    end
  end

  def my_favorite?(user)
    favorites.find_by(user_id: user.id).present?
  end
end
