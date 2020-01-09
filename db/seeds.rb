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
