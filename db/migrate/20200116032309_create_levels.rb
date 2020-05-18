class CreateLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :levels do |t|
      t.integer :threshold, null: false, default: 0

      t.timestamps
    end
  end
end
