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

  after_create :set_first_cycle

  validates :content, length: { maximum: 3000 }
  # validates :is_public, inclusion: { in: [false] }, if: :imported?

  scope :to_review_today, -> { where('review_date <= ?', Time.zone.today) }
  scope :to_review_this_day,
        ->(date) { where('review_date = ? AND review_date >= ?', date, Time.zone.today) }
  scope :review_date_asc, -> { order(review_date: 'ASC') }
  scope :latest, -> { order(created_at: 'DESC') }
  scope :all_or_weekly, ->(weekly) do
    if weekly
      where('created_at >= ?', Time.current.beginning_of_week)
    else
      all
    end
  end

  ransacker :favorites_count do
    query = '(SELECT COUNT(favorites.learned_content_id) FROM favorites WHERE favorites.learned_content_id = learned_contents.id GROUP BY favorites.learned_content_id)'
    Arel.sql(query)
  end

  def till_next_review
    @till_next_review ||= (review_date - Time.zone.today).to_i
  end

  def create_temporary_related_images(related_image_array)
    # related_image_arrayの1つ目は空、updateの場合も新しく保存された画像のみを含む
    related_image_array.each_with_index do |related_image, index|
      next if index.zero?

      image_links = related_image.split(' ') # [0]大画像リンク、[1]サムネリンク、[2]word
      new_image = self.related_images.create!(thumbnail_url: image_links[1], word: image_links[2])
      RelatedImagesUploadJob.perform_later(related_image: new_image, image_url: image_links[0])
    end
  end

  def create_related_words(related_word_array)
    self.related_words.destroy_all # updateの場合はresetしてから
    related_word_array.each_with_index do |related_word, index|
      # related_word_arrayの1つ目は空
      # main wordの場合を除く
      next if index.zero? || self.word_definition.word == related_word

      word_definition_id = WordDefinition.find_by(word: related_word).id
      self.related_words.create!(word_definition_id: word_definition_id)
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
    if (next_cycle = user.cycles.find_by(times: times)&.cycle)
      update(review_date: Time.zone.today + next_cycle)
    else
      update(review_date: Time.zone.today + 10000, completed: true)
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

  def copy_content_to(user, calendar_today)
    user.learned_contents.create!(
      user_id: user.id,
      calendar_id: calendar_today.id,
      word_definition_id: word_definition_id,
      word_category_id: word_category_id,
      content: content,
      imported_from: id,
      imported: true,
      is_public: false,
      completed: false
    )
  end

  def duplicate_children_to(learned_content)
    ['related_image', 'related_word', 'question'].each do |model|
      send("#{model}s").each do |object|
        duplicated = object.dup
        duplicated.learned_content = learned_content
        if model == 'related_image'
          duplicated.image = object.image.file
        end
        duplicated.save!
      end
    end
  end

  private

  def set_first_cycle
    return if review_date.present?

    first_cycle = user.cycles.find_by(times: 0).cycle
    update!(review_date: Time.zone.today + first_cycle)
  end
end
