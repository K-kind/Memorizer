class CreateConsultedWords < ActiveRecord::Migration[6.0]
  def change
    create_table :consulted_words do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :word_definition, null: false, foreign_key: true

      t.timestamps
    end
  end
end
