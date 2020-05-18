class AddLargeImageLinkToRelatedImages < ActiveRecord::Migration[6.0]
  def change
    add_column :related_images, :large_image_link, :text
  end
end
