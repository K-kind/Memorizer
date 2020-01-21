module HomesHelper
  def reviewed_count_today
    current_user.review_histories.where('review_histories.created_at >= ?', Time.zone.today.beginning_of_day).count
  end

  def contents_to_review_today
    current_user.learned_contents.to_review_today
  end

  def learned_contents_today
    current_user.learned_contents.where('created_at >= ?', Time.zone.today.beginning_of_day)
  end
end
