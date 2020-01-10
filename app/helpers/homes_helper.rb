module HomesHelper
  def reviewed_count_today
    current_user.learned_contents.inject(0) do |sum, learned_content|
      sum + learned_content.review_histories.where('created_at >= ?', Time.zone.today.beginning_of_day).count
    end
  end
  
  def contents_to_review_today
    current_user.learned_contents.where('till_next_review <= 0').count
  end

  def learned_contents_today
    current_user.learned_contents.where('created_at >= ?', Time.zone.today.beginning_of_day).count
  end
end
