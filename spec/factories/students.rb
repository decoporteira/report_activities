FactoryBot.define do
  factory :student do
    sequence(:name) { |n| "Jon Doe#{n}" }
    status { :registered }
    sequence(:email) { |n| "student#{n}@email.com" }
    association :classroom
  end
end
