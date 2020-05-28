class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :test_logged_in_at, :datetime
    add_column :users, :test_logged_in_by, :string
  end
end
