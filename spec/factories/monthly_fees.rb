FactoryBot.define do
  factory :monthly_fee do
    student
    value { '100' }
    status { 1 }
    due_date { '2024-06-11' }
  end
end
