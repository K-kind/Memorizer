module HomesHelper
  def reviewed_count_today
    current_user.calendars
                .find_by(calendar_date: Time.zone.today)
                .review_histories
                .count
  end

  def contents_to_review_today
    current_user.learned_contents.to_review_today
  end

  # def learned_contents_today
  #   current_user.calendars
  #               .find_by(calendar_date: Time.zone.today)
  #               .learned_contents
  # end
end
