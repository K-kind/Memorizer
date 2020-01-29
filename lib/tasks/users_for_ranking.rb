test_admin = User.find_by(is_test_user: true, name: 'テスト管理ユーザー')
15.times do |n|
  fake_user = User.find_or_create_by!(email: "fake_user#{n}@memorizer.tech") do |user|
    user.name = Faker::Internet.user_name
    user.password = 'password'
    user.activated = true
    user.user_skill_id = UserSkill.first.id
    user.level_id = 1 + (n / 2).floor
  end
  calendar = fake_user.calendars.find_or_create_by!(calendar_date: Time.zone.today)
  original = LearnedContent.first
  (n + 1).times do |m|
    learned_content = fake_user.learned_contents.create!(
      word_category_id: WordCategory.first.id,
      word_definition_id: WordDefinition.first.id,
      is_public: false,
      imported: true,
      calendar_id: calendar.id,
      content: original.content,
    )
    learned_content.questions.create!(
      question: Faker::Lorem.sentence,
      answer: Faker::Lorem.word
    )
    favorite = test_admin.favorites.find_or_create_by!(learned_content_id: learned_content.id)
    if m <= 4 # 5個以上が今週分になる
      learned_content.update!(created_at: Time.zone.today - 7)
      favorite.update!(created_at: Time.zone.today - 7)
    end
  end
end
