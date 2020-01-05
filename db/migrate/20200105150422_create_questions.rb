class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :questions do |t|
      t.references :learned_content, null: false, foreign_key: true
      t.text :question
      t.string :answer

      t.timestamps
    end
  end
end
