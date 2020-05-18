class AddCalendarIdToReviewHistories < ActiveRecord::Migration[6.0]
  def change
    add_reference :review_histories, :calendar, null: false, foreign_key: true
  end
end
