class AddThumbnailUrlToRelatedImages < ActiveRecord::Migration[6.0]
  def change
    add_column :related_images, :thumbnail_url, :string
  end
end
