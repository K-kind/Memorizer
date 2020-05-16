class RenameLevelIdToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :level_id, :level
  end
end
