class RemoveColumnFromLearnedContents < ActiveRecord::Migration[6.0]
  class LearnedContent < ActiveRecord::Base
  end

  def up
    LearnedContent.find_each do |learned_content|
      learned_content.update!(review_date: Time.zone.today + learned_content.till_next_review)
    end
    remove_column :learned_contents, :till_next_review, :integer
  end

  def down
    add_column :learned_contents, :till_next_review, :integer, default: 1
  end
end
