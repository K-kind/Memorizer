# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UserSkill.find_or_create_by!(skill: '高校受験')
UserSkill.find_or_create_by!(skill: '大学受験')
UserSkill.find_or_create_by!(skill: 'TOEIC600点相当')
UserSkill.find_or_create_by!(skill: 'TOEIC700点相当')
UserSkill.find_or_create_by!(skill: 'TOEIC800点相当')
UserSkill.find_or_create_by!(skill: 'TOEIC900点相当')

WordCategory.find_or_create_by!(category: 'General')
WordCategory.find_or_create_by!(category: 'Science')
WordCategory.find_or_create_by!(category: 'Technology')
WordCategory.find_or_create_by!(category: 'Business')

# 最初だけ頻繁にレベルが上がり過ぎないようにする
Level.find_or_create_by!(threshold: 7)
Level.find_or_create_by!(threshold: 17)
Level.find_or_create_by!(threshold: 32)
Level.find_or_create_by!(threshold: 52)
Level.find_or_create_by!(threshold: 77)
# 6レベル以降はthresholdを緩やかに上げる
300.times do |n|
  id = n + 6
  threshold = Level.find(id - 1).threshold + 20 + (id / 10).floor
  Level.find_or_create_by!(threshold: threshold)
end

# 管理者を作成
email = Rails.application.credentials.dig(:seed, :admin_email)
password = Rails.application.credentials.dig(:seed, :admin_password)
Admin.find_or_create_by!(email: email) do |admin|
  admin.password = password
end

# テストユーザーの問題を管理するユーザー
test_admin_email = Rails.application.credentials.dig(:seed, :test_admin_email)
test_admin_password = Rails.application.credentials.dig(:seed, :test_admin_password)
User.find_or_create_by!(email: test_admin_email) do |user|
  user.password = test_admin_password
  user.name = 'テスト管理ユーザー'
  user.activated = true
  user.is_test_user = true
  user.user_skill_id = UserSkill.fifth.id
end

# テストユーザーを作成
6.times do |n|
  User.find_or_create_by!(email: "test_user#{n}@memorizer.tech") do |user|
    user.password = Rails.application.credentials.dig(:seed, :test_password)
    user.name = "テストユーザー#{n}"
    user.is_test_user = true
    user.user_skill_id = UserSkill.fifth.id
  end
end
