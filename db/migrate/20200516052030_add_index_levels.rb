class AddIndexLevels < ActiveRecord::Migration[6.0]
  def change
    add_index :levels, :level
  end
end
