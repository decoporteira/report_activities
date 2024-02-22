FactoryBot.define do
  factory :attendance do
    student { nil }
    presence { false }
    attendance_date { '2023-12-29' }
  end
end
