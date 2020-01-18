class RenameSignedUpColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :signed_up, :is_test_user
  end
end
