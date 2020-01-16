# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

UserSkill.find_or_create_by!(skill: '高校受験')
UserSkill.find_or_create_by!(skill: '大学受験')
UserSkill.find_or_create_by!(skill: '難関大学')
UserSkill.find_or_create_by!(skill: 'TOEIC600点台')
UserSkill.find_or_create_by!(skill: 'TOEIC700点台')
UserSkill.find_or_create_by!(skill: 'TOEIC800点台')
UserSkill.find_or_create_by!(skill: 'TOEIC900点台')

WordCategory.find_or_create_by!(category: 'General')
WordCategory.find_or_create_by!(category: 'Science')
WordCategory.find_or_create_by!(category: 'Technology')

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
