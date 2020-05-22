class RelatedImage < ApplicationRecord
  belongs_to :learned_content
  mount_uploader :image, ImageUploader

  validates :word, presence: true

  def upload_large_image(image_url)
    update!(remote_image_url: image_url)
  end
end
