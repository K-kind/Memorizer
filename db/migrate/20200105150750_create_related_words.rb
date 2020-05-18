class CreateRelatedWords < ActiveRecord::Migration[6.0]
  def change
    create_table :related_words do |t|
      t.references :learned_content, null: false, foreign_key: true
      t.references :word_definition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
