FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email1#{n}@email.com" }
    role { 'admin' }
    password { 'password' }
  end
  factory :user_two, class: User do
    sequence(:email) { |n| "email2#{n}@email.com" }
    role { 'default' }
    password { 'password' }
  end
end
