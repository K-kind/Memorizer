class AddIsTestToLearnedContents < ActiveRecord::Migration[6.0]
  def change
    add_column :learned_contents, :is_test, :boolean, default: false
  end
end
