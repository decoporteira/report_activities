require 'rails_helper'

RSpec.describe 'Usuário edita Plano atual para aluno' do
  it 'com sucesso' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:plan, name: 'Teens', price: 350)
    student = FactoryBot.create(:student, name: 'Brock')
    FactoryBot.create(:current_plan, student_id: student.id)

    login_as(user)
    visit(root_path)
    click_on('Finanças')
    click_on('Curso por aluno')
    click_on("Show Brock's current plan")
    click_on('Edit this current plan')
    check('Tem desconto')
    fill_in 'Desconto', with: 40
    select 'Teens', from: 'current_plan_plan_id'
    select 'Brock', from: 'current_plan_student_id'
    click_on 'Atualizar Plano Atual'

    expect(page).to have_content('Plano atual editado com sucesso.')
    expect(page).to have_content('Curso: Teens')
    expect(page).to have_content('Desconto: Desconto cadastrado')
    expect(page).to have_content('Valor do desconto: R$ 40,00')
    expect(page).to have_content('Aluno: Brock')
    expect(page).to have_content('Valor total: R$ 310,00')
  end
end
