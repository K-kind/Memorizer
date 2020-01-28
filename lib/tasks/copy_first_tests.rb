# 初回のみ実行
test_admin = User.find_by(is_test_user: true, name: 'テスト管理ユーザー')
User.where('is_test_user = ? AND name != ?', true, 'テスト管理ユーザー').each do |user|
  calendar_today = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 1)
  calendar_previous_review = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 4)
  calendar_previous = user.calendars.find_or_create_by!(calendar_date: Time.zone.today - 7)
  test_admin.learned_contents.each_with_index do |original_content, index|
    learned_content = user.import_content(original_content, calendar_today)
    original_content.duplicate_children(learned_content)

    if index <= 2
      learned_content.review_histories.create(
        similarity_ratio: 90,
        calendar_id: calendar_previous_review.id
      )
      learned_content.update(till_next_review: 3, calendar_id: calendar_previous.id, is_test: true)
    else
      learned_content.update(till_next_review: 0, is_test: true)
    end
    user.set_calendar_to_review(learned_content.till_next_review)
  end
end
