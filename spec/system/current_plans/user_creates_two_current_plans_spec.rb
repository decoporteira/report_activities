require 'rails_helper'

RSpec.describe 'Usuário cria Plano atual para aluno' do
  it 'com sucesso' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:plan, name: 'Teste', price: 330)
    FactoryBot.create(:plan, name: 'Teens', price: 350)
    student = FactoryBot.create(:student, name: 'Brock')
    FactoryBot.create(:current_plan, student_id: student.id)

    login_as(user)
    visit(root_path)
    click_on('Finanças')
    click_on('Curso por aluno')
    click_on('Criar um novo plano para um aluno')
    fill_in 'Desconto', with: 10
    check('Tem desconto')
    select 'Kids', from: 'current_plan_plan_id'
    select 'Brock', from: 'current_plan_student_id'
    click_on 'Criar Plano Atual'

    expect(page).to have_content('Aluno already has a current plan.')
  end
end
