class CreateCycles < ActiveRecord::Migration[6.0]
  def change
    create_table :cycles do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :times
      t.integer :cycle

      t.timestamps
    end
  end
end
