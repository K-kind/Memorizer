number = (Time.zone.now.min / 10).floor # 分の10の位を取得
if number == 5
  user_number = 0
else
  user_number = number + 1
end
user = User.find_by(email: "test_user#{user_number}@memorizer.tech")
['review_histories', 'consulted_words', 'later_lists'].each do |objects|
  user.send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 12.hours).destroy_all
end
user.learned_contents.where(is_test: false).destroy_all
user.rollback_to_default_cycle
user.learned_contents.each.with_index(1) do |learned_content, index|
  # 1, 6, 7問目は本日復習ができる
  learned_content.update!(review_date: Time.zone.today) if index.in?([1, 6, 7])
end
test_admin = User.find_by(email: Rails.application.credentials.dig(:seed, :test_admin_email))
user.reset_test_words(test_admin)
user.reset_test_contacts(test_admin)
user.reset_test_notification
user.update!(exp: 0, level: 1)
