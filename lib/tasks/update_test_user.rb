number = (Time.zone.now.min / 10).floor # 分の10の位を取得
if number == 5
  user_number = 0
else
  user_number = number + 1
end
user = User.find_by(email: "test_user#{user_number}@memorizer.tech")
%w[review_histories consulted_words later_lists calendars].each do |objects|
  user.send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 12.hours).destroy_all
end
user.learned_contents.where(is_test: false).destroy_all
user.rollback_to_default_cycle
user.learned_contents.each.with_index(1) do |learned_content, index|
  # 1, 6, 7問目は本日復習ができる
  learned_content.update!(review_date: Time.zone.today) if index.in?([1, 6, 7])
end
test_admin = User.find_by(email: Rails.application.credentials.dig(:seed, :test_admin_email))
user.favorites.destroy_all
user.reset_test_words(test_admin)
user.reset_test_contacts(test_admin)
user.reset_test_notification
user.update!(exp: 0, level: 1)

# 次の日になった時
unless user.calendars.find_by(calendar_date: Time.zone.today + 6)
  user.learned_contents.each do |learned_content|
    old_date = learned_content.calendar.calendar_date
    calendar = user.calendars.find_by(calendar_date: old_date + 1)
    calendar ||= user.calendars.create!(
      calendar_date: old_date + 1, created_at: Time.zone.yesterday
    )
    learned_content.update!(
      calendar_id: calendar.id,
      created_at: learned_content.created_at + 1.day
    )

    # review_history 実際は1つだけ
    learned_content.review_histories.each do |review_history|
      old_reviewed_date = review_history.calendar.calendar_date
      review_calendar = user.calendars.find_by(calendar_date: old_reviewed_date + 1)
      review_calendar ||= user.calendars.create!(
        calendar_date: old_reviewed_date + 1, created_at: Time.zone.yesterday
      )
      review_history.update!(
        calendar_id: review_calendar.id,
        created_at: review_history.created_at + 1.day
      )
    end
  end
  user.calendars.find_by(calendar_date: Time.zone.today - 9)&.destroy
end
