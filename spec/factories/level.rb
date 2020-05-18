FactoryBot.define do
  factory :level do
    level { 1 }
    threshold { 7 }
  end

  trait :level2 do
    level { 2 }
    threshold { 17 }
  end
end
