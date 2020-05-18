class AddImageToRelatedImages < ActiveRecord::Migration[6.0]
  def change
    add_column :related_images, :image, :string
  end
end
