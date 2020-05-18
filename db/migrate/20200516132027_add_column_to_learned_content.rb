class AddColumnToLearnedContent < ActiveRecord::Migration[6.0]
  def change
    add_column :learned_contents, :review_date, :date
  end
end
