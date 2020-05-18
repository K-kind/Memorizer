class CreateLaterLists < ActiveRecord::Migration[6.0]
  def change
    create_table :later_lists do |t|
      t.references :user, foreign_key: true
      t.string :word
      t.timestamps
    end
  end
end
