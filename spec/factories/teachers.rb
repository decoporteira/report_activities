FactoryBot.define do
  factory :teacher do
          name { 'deco' }
          status { 1}
          
  end
  factory :teacher2, class: Teacher do
    name { '' }
    status { 1 }
  end
end
