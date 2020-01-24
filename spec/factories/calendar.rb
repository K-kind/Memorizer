FactoryBot.define do
  factory :calendar do
    calendar_date { Time.zone.today }
    user
  end
end
