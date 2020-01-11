class AddCalendarIdToLearnedContents < ActiveRecord::Migration[6.0]
  def change
    add_reference :learned_contents, :calendar, null: false, foreign_key: true
  end
end
