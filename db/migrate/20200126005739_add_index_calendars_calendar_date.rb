class AddIndexCalendarsCalendarDate < ActiveRecord::Migration[6.0]
  def up
    add_index :calendars, [:calendar_date, :user_id], unique: true
  end

  def down
    remove_index :calendars, column: [:calendar_date, :user_id]
  end
end
