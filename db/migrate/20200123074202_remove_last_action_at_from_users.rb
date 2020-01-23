class RemoveLastActionAtFromUsers < ActiveRecord::Migration[6.0]
  def up
    remove_column :users, :last_action_at
  end
  
  def down
    add_column :users, :last_action_at
  end
end
