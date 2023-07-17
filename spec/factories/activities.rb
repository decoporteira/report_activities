FactoryBot.define do
  factory :activity do
    student 
    report {"Teste de texto"}
    late { 0 }
    date { 02/05}
  end
end
