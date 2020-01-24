FactoryBot.define do
  factory :review_history do
    similarity_ratio { 100 }
    learned_content
    calendar
  end
end
