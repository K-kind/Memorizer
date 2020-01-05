class CreateLearnedContents < ActiveRecord::Migration[6.0]
  def change
    create_table :learned_contents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :word_category, null: false, foreign_key: true
      t.references :word_definition, null: false, foreign_key: true
      t.boolean :is_public, default: true
      t.integer :till_next_review, default: 1
      t.timestamps
    end
  end
end
