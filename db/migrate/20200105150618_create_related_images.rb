class CreateRelatedImages < ActiveRecord::Migration[6.0]
  def change
    create_table :related_images do |t|
      t.references :learned_content, null: false, foreign_key: true
      t.text :image_link

      t.timestamps
    end
  end
end
