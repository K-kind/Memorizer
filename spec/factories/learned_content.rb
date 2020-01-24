FactoryBot.define do
  factory :learned_content do
    content { 'テストです' }
    user
    word_definition
    word_category
    calendar
  end
end
