class LearnedContent < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :related_images, dependent: :destroy
  has_many :related_words, dependent: :destroy
  has_many :review_histories, dependent: :destroy
  belongs_to :user
  belongs_to :word_category
  belongs_to :word_definition

  has_rich_text :content
  accepts_nested_attributes_for :related_words
  accepts_nested_attributes_for :related_images
end
