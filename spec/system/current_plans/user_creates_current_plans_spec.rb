require 'rails_helper'

RSpec.describe 'Usuário cria Plano atual para aluno' do
  it 'com sucesso' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:plan, name: 'Teens', price: 350)
    FactoryBot.create(:student, name: 'Brock')

    login_as(user)
    visit(root_path)
    click_on('Finanças')
    click_on('Curso por aluno')
    click_on('New current plan')
    fill_in 'Desconto', with: 10
    check('Tem desconto')
    select 'Kids', from: 'current_plan_plan_id'
    select 'Brock', from: 'current_plan_student_id'
    click_on 'Criar Plano Atual'

    expect(page).to have_content('Plano atual criado com sucesso')
    expect(page).to have_content('Curso: Kids')
    expect(page).to have_content('Desconto: Desconto cadastrado')
    expect(page).to have_content('Valor do desconto: R$ 10,00')
    expect(page).to have_content('Aluno: Brock')
    expect(page).to have_content('Valor total: R$ 320,00')
  end

  it 'falha pois desconto é maior que mensalidade' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:student, name: 'Brock')

    login_as(user)
    visit(root_path)
    click_on('Finanças')
    click_on('Curso por aluno')
    click_on('New current plan')
    fill_in 'Desconto', with: 331
    check('Tem desconto')
    select 'Kids', from: 'current_plan_plan_id'
    select 'Brock', from: 'current_plan_student_id'
    click_on 'Criar Plano Atual'

    expect(page).to have_content('Valor da mensalidade não pode ser negativa.')
  end
end
