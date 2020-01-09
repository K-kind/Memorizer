class LearnedContent < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :related_images, dependent: :destroy
  has_many :related_words, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  belongs_to :user
  belongs_to :word_category
  belongs_to :word_definition

  has_rich_text :content
  accepts_nested_attributes_for :questions
  # enum is_public: { Public: true, Private: false }

  def create_related_images(related_image_array)
    related_image_array.each_with_index do |related_image, index|
      unless index.zero?
        image_links = related_image.split(' ')
        self.related_images.create!(large_image_link: image_links[0], image_link: image_links[1], word: image_links[2])
      end
    end
  end

  def create_related_words(related_word_array)
    related_word_array.each_with_index do |related_word, index|
      unless index.zero? || self.word_definition.word == related_word
        word_definition_id = WordDefinition.find_by(word: related_word).id
        self.related_words.create!(word_definition_id: word_definition_id)
      end
    end
  end
end
