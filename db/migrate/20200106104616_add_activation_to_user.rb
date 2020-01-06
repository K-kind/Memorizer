class AddActivationToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :activated_at, :datetime
    rename_column :users, :active, :activated
  end
end
