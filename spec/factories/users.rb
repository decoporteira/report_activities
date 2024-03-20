FactoryBot.define do
  factory :user do
    email { 'decdo@gmail.com' }
    role { 'admin' }
    password { 'password' }
  end
  factory :user_two, class: User do
    email { 'carlodsds@gmail.com' }
    role { 'default' }
    password { 'password' }
  end
end
