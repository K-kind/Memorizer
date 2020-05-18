class RelatedImage < ApplicationRecord
  belongs_to :learned_content
  mount_uploader :image, ImageUploader

  validates :word, presence: true
  validates :image, presence: true
end
