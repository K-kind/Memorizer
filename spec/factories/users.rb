FactoryBot.define do
  sequence :email do |n|
    "example#{n}@email.com"
  end

  factory :user do
    name { 'テストユーザー' }
    email
    password { 'password' }
    activated { true }
    activated_at { Time.zone.now }
    user_skill
  end
end
