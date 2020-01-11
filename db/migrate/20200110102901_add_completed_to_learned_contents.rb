class AddCompletedToLearnedContents < ActiveRecord::Migration[6.0]
  def change
    add_column :learned_contents, :completed, :boolean, default: false
  end
end
