class AddWordToRelatedImages < ActiveRecord::Migration[6.0]
  def change
    add_column :related_images, :word, :string
  end
end
