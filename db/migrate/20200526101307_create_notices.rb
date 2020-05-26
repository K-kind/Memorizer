class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.text :content
      t.datetime :expiration
      t.integer :type

      t.timestamps
    end
  end
end
