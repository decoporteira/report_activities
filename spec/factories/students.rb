FactoryBot.define do
  factory :student do
    name { 'Ash Ketchum'}
    status { 1 }
    association :classroom
  end

  factory :student_two, class: 'Student' do
    name { 'Carlos' }
    status { 1 }
    association :classroom
  end
end
