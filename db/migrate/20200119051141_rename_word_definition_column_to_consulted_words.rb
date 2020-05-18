class RenameWordDefinitionColumnToConsultedWords < ActiveRecord::Migration[6.0]
  def change
    rename_column :consulted_words, :word_definition, :word_definition_id
  end
end
