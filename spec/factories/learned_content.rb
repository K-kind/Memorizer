FactoryBot.define do
  factory :learned_content do
    content { 'テストです' }
    user
    word_definition
    word_category
    calendar
    review_date { Time.zone.today + 1 }
  end
end
