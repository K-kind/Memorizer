class AddImportedToLearnedContents < ActiveRecord::Migration[6.0]
  def change
    add_column :learned_contents, :imported, :boolean, default: false
  end
end
