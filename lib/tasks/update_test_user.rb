number = (Time.zone.now.min / 10).floor # 分の10の位を取得
if number == 5
  user_number = 0
else
  user_number = number + 1
end
user = User.find_by(email: "test_user#{user_number}@memorizer.tech")
['review_histories', 'contacts', 'consulted_words', 'later_lists'].each do |objects|
  user.send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 65.minutes).destroy_all
end
user.learned_contents.where(is_test: false).destroy_all
user.rollback_to_default_cycle
user.learned_contents.each_with_index do |learned_content, index|
  if index <= 2
    learned_content.update!(till_next_review: 3)
  else
    learned_content.update!(till_next_review: 0)
  end
end
user.set_test_words
user.update!(exp: 0, level_id: 1)
