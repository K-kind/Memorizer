class RemoveQuestionTypeFormLearnedContents < ActiveRecord::Migration[6.0]
  def change
    remove_column :questions, :question_type, :integer, default: 0
  end
end
