class LearnedContent < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :related_images, dependent: :destroy
  has_many :related_words, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :user
  belongs_to :word_category
  belongs_to :word_definition, optional: true
  belongs_to :calendar
  has_rich_text :content
  accepts_nested_attributes_for :questions

  validate :validate_word_definition
  validates :content, length: { maximum: 3000 }
  validate :validate_public_when_imported
  validate :validate_questions, on: :self_learn
  validate :validate_related_images, on: :self_learn

  after_create :set_first_cycle
  attr_accessor :temporary_images

  scope :latest, -> { order(created_at: 'DESC') }
  scope :review_date_asc, -> { order(review_date: 'ASC') }
  scope :to_review_today, -> { where('review_date <= ?', Time.zone.today) }
  scope :to_review_this_day,
        ->(date) { where('review_date = ? AND review_date >= ?', date, Time.zone.today) }

  scope :for_q_and_words,
        -> { includes([:word_definition, :questions, { related_words: :word_definition }]) }

  scope :with_favorites_count,
        -> {
          left_joins(:favorites)
            .select(
              'learned_contents.*,
              COUNT(distinct favorites.id) AS favorites_count'
            ).group(:id)
        }

  scope :with_reviewed_count,
        -> {
          left_joins(:review_histories)
            .select(
              'learned_contents.*,
              COUNT(distinct review_histories.id) AS reviewed_count'
            ).group(:id)
        }

  scope :word_search_for,
        ->(word_definition_ids) {
          left_joins(:related_words)
            .where(
              'learned_contents.word_definition_id IN (?) OR
              related_words.word_definition_id IN (?)',
              word_definition_ids, word_definition_ids
            ).group(:id)
        }

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

  def validate_word_definition
    return unless word_definition_id.nil?

    errors.add(:base, '1つ以上の単語を検索してください。')
  end

  def validate_public_when_imported
    return unless imported? && is_public?

    errors.add(:base, 'ダウンロードされたコンテンツは公開できません。')
  end

  def validate_questions
    return if questions.any? do |question|
      !question.question.blank? || !question.answer.blank?
    end

    errors.add(:base, '1つ以上の問題を入力してください。')
  end

  def validate_related_images
    # @temporary_imagesは配列の1つ目が空
    return if related_images.length + temporary_images&.length.to_i - 1 <= 3

    errors.add(:base, '画像は3枚まで保存できます。')
  end

  def till_next_review
    @till_next_review ||= (review_date - Time.zone.today).to_i
  end

  def create_temporary_related_images
    # @temporary_imagesの1つ目は空であり、updateの場合も新しく保存された画像のみを含む
    @temporary_images.each_with_index do |related_image, index|
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

  def duplicate_children_to(new_content)
    %w[related_word question].each do |original_model|
      send("#{original_model}s").each do |original_object|
        duplicated = original_object.dup
        duplicated.learned_content = new_content
        duplicated.save!
      end
    end

    # related_imagesの処理だけ例外が多いので分ける
    related_images.each do |original_image|
      new_image = new_content.related_images.create!(
        word: original_image.word,
        thumbnail_url: original_image.image.url
      )
      # importedされたrelated_imageに、元の画像のurlをアップロード
      RelatedImagesUploadJob.perform_later(related_image: new_image,
                                           image_url: original_image.image.url)
    end
  end

  private

  def set_first_cycle
    return if review_date.present?

    first_cycle = user.cycles.find_by(times: 0).cycle
    update!(review_date: Time.zone.today + first_cycle)
  end
end
