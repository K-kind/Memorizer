FactoryBot.define do
  factory :question do
    question { 'テストq' }
    answer { 'テストa' }
    learned_content
  end
end
