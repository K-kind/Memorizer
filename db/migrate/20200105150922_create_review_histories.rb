class CreateReviewHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :review_histories do |t|
      t.references :learned_content, null: false, foreign_key: true
      t.boolean :again, default: false
      t.integer :similarity_ratio

      t.timestamps
    end
  end
end
