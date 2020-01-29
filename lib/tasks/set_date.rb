LearnedContent.where(is_test: false).update_all('till_next_review = till_next_review - 1')

User.where('is_test_user = ? AND name != ?', true, 'テスト管理ユーザー').each do |user|
  calendar_7days_ago = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 7)
  calendar_4days_ago = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 4)
  calendar_1day_ago = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 1)
  user.learned_contents.where(is_test: true).each_with_index do |learned_content, index|
    if index <= 2
      learned_content.update!(calendar_id: calendar_7days_ago.id, till_next_review: 3)
      learned_content.review_histories.update_all(calendar_id: calendar_4days_ago)
    else
      # till_next_reviewは1時間おきに0にされている
      learned_content.update!(calendar_id: calendar_1day_ago.id)
    end
  end
  user.calendars.find_by(calendar_date: Time.zone.today - 8).destroy
  user.calendars.find_or_create_by!(calendar_date: Time.zone.today)
  user.contacts.update_all(created_at: Time.zone.today)
end
