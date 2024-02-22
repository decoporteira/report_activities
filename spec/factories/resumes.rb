FactoryBot.define do
  factory :resume do
    written_report { 'MyText' }
    status { 1 }
    date { '2023-11-09' }
    student_id { nil }
  end
end
