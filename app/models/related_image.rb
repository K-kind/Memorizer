class RelatedImage < ApplicationRecord
  belongs_to :learned_content
  mount_uploader :image, ImageUploader
  # skip_callback :commit, :after, :remove_avatar!
  # skip_callback :commit, :after, :remove_previously_stored_avatar
end
