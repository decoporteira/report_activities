require 'rails_helper'

RSpec.describe 'Usuário cadastra um Plano' do
  it 'com sucesso' do
    initial_count = Plan.count
    Plan.create!(name: 'Turma infantil', price: 330.00)

    expect(Plan.count).to eq(initial_count + 1)
    expect(plan.name).to eq('Turma infantil')
    expect(plan.price).to eq(330.00)
  end
end
