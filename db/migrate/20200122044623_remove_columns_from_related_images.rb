class RemoveColumnsFromRelatedImages < ActiveRecord::Migration[6.0]
  def up
    remove_column :related_images, :large_image_link
    remove_column :related_images, :image_link
  end
  
  def down
    add_column :related_images, :large_image_link, :text
    add_column :related_images, :image_link, :text
  end
end
