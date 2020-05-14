FactoryBot.define do
  factory :user_skill do
    skill { 'TOEIC800点相当' }
  end

  factory :user_skill_900, class: UserSkill do
    skill { 'TOEIC900点相当' }
  end
end
