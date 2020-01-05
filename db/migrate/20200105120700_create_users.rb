class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.references :user_skill, foreign_key: true
      t.string :name
      t.string :email
      t.integer :exp, default: 0
      t.string :password_digest
      t.string :activation_digest
      t.string :reset_digest
      t.string :remember_digest
      t.datetime :reset_sent_at
      t.string :uid
      t.string :provider
      t.boolean :active, default: false
      t.boolean :signed_up, default: false
      t.datetime :last_action_at

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end