class AddColumnLevels < ActiveRecord::Migration[6.0]
  def change
    add_column :levels, :level, :integer
  end
end
