class CreateWordDefinitions < ActiveRecord::Migration[6.0]
  def change
    create_table :word_definitions do |t|
      t.string :word
      t.json :dictionary_data
      t.json :thesaurus_data

      t.timestamps
    end
    add_index :word_definitions, :word, unique: true
  end
end
