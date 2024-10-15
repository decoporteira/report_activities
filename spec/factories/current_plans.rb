FactoryBot.define do
  factory :current_plan do
    association :plan
    association :student
    has_discount { false }
    discount { 0 }
  end
end
