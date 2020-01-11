class AddUserIdToCalendars < ActiveRecord::Migration[6.0]
  def change
    add_reference :calendars, :user, null: false, foreign_key: true
  end
end
