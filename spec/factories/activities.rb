FactoryBot.define do
  factory :activity do
    student
    report { 'Teste de texto' }
    late { 0 }
    date { 0o2 / 0o5 }
  end
end
