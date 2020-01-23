class RelatedImage < ApplicationRecord
  belongs_to :learned_content
  mount_uploader :image, ImageUploader
end
