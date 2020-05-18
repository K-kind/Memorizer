class AddLevelIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :level_id, :integer, default: 1
  end
end
