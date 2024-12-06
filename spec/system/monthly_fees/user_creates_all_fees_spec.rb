require 'rails_helper'

RSpec.describe 'Cria todas as mensalidades do ano' do
  it 'com sucesso' do
    admin = FactoryBot.create(:user, role: 'admin')
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, teacher_id: teacher.id) 
    student = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    student_b = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)
    student_c = FactoryBot.create(:student, name: 'Squirtle', classroom_id: classroom.id)
    FactoryBot.create(:student, name: 'Caterpie', classroom_id: classroom.id)
    FactoryBot.create(:student, name: 'Stariu', status: 'unregistered', classroom_id: classroom.id)
    plan = FactoryBot.create(:plan, name: 'Kids', price: 300)
    plan_b = FactoryBot.create(:plan, name: 'Adult', price: 350)
    FactoryBot.create(:current_plan, plan:, student:)
    FactoryBot.create(:current_plan, plan:, student: student_b)
    FactoryBot.create(:current_plan, plan: plan_b, student: student_c)

    login_as(admin)
    visit(root_path)
    click_on('Finanças')
    click_on('Mensalidades')
    click_on('Criar todas as Mensalidades')

    expect(page).to have_content('Venossaur')
    expect(page).to have_content('R$ 300,00')
    expect(page).to have_content('A pagar')
    expect(page).to have_content('dezembro / 2024')
    expect(page).to have_content('Charmander')
    expect(page).to have_content('Squirtle')
    expect(page).not_to have_content('Caterpie')
    expect(page).not_to have_content('Stariu')
    expect(page).to have_content('Mensalidades criadas com sucesso.')
    expect(MonthlyFee.count).to eq(3)
  end
end
