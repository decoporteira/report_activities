FactoryBot.define do
  factory :user do
      email { 'decdo@gmail.com' }
      role { 1}
      password {'password'}
    
  end
  factory :user_two, class: User do
    email { 'carlodsds@gmail.com' }
    role { 1}
    password {'password'}
  
  end
  
end
