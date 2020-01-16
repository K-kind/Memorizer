class AddImportedFromToLearnedContents < ActiveRecord::Migration[6.0]
  def change
    add_column :learned_contents, :imported_from, :integer
    add_index :learned_contents, [:user_id, :imported_from]
    add_index :learned_contents, [:created_at, :imported_from, :is_public], name: 'index_learned_contents_imported_latest'
  end
end
