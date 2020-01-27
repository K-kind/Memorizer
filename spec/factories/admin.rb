FactoryBot.define do
  sequence :admin_email do |n|
    "admin#{n}@memorizer.tech"
  end

  factory :admin do
    email
    password { 'password' }
  end
end
