class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :to_admin, default: false
      t.boolean :checked, default: false
      t.integer :action, default: 1
      t.integer :contact_id

      t.timestamps
    end
  end
end
