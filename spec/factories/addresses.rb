FactoryBot.define do
  factory :address do
    street { 'MyString' }
    number { 1 }
    unit { 'MyString' }
    neighborhood { 'MyString' }
    state { 'MyString' }
    country { 'MyString' }
    zip_code { 'MyString' }
    student { nil }
  end
end
