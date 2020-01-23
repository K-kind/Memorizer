number = (Time.zone.now.min / 10).floor # 分の10の位を取得
if number == 5
  user_number = 0
else
  user_number = number + 1
end
user = User.find_by(email: "test_user#{user_number}@memorizer.tech")
['learned_contents', 'contacts', 'consulted_words', 'later_lists'].each do |objects|
  user.send(objects).where("#{objects}.created_at >= ?", Time.zone.now - 65.minutes).destroy_all
end
user.review_histories.where('review_histories.created_at >= ?', Time.zone.now - 65.minutes).each do |review_history|
  parent = review_history.learned_content
  review_history.destroy
  parent.set_next_cycle
end
user.set_test_words
