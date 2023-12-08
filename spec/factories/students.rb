FactoryBot.define do
  factory :student do
      name { 'deco' }
      status { 1}
      classroom
  end
  factory :student_two, class: Student do
    name { 'Carlos' }
    status { 1 }
    classroom
  end
end
