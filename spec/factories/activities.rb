FactoryBot.define do
  factory :activity do
    student
    report { 'Teste de texto' }
    late { 0 }
    date { Time.zone.today }
  end
end
