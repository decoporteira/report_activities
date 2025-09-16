require 'rails_helper'

RSpec.describe 'Admin ve todos os usuários com mensalidades atrasadas' do
  it 'editando o valor' do
    admin = FactoryBot.create(:user, role: :admin)

    student_one = FactoryBot.create(:student, name: 'Charmander')
    student_two = FactoryBot.create(:student, name: 'Bulbassaur')
    student_three = FactoryBot.create(:student, name: 'Squirtle')
    student_four = FactoryBot.create(:student, name: 'Caterpie', status: :unregistered)
    student_five = FactoryBot.create(:student, name: 'Gengar')

    plan_one = FactoryBot.create(:plan, name: 'Kids', price: 300, billing_type: 'monthly')
    plan_two = FactoryBot.create(:plan, name: 'Private', price: 300, billing_type: 'per_class')
     
    FactoryBot.create(:current_plan, student_id: student_one.id, plan_id: plan_one.id)
    FactoryBot.create(:current_plan, student_id: student_two.id, plan_id: plan_one.id)
    FactoryBot.create(:current_plan, student_id: student_three.id, plan_id: plan_one.id)
    FactoryBot.create(:current_plan, student_id: student_four.id, plan_id: plan_one.id)
    FactoryBot.create(:current_plan, student_id: student_five.id, plan_id: plan_two.id)
    

    FactoryBot.create(:monthly_fee, student_id: student_one.id, status: 'Atrasada', due_date: Date.new(Time.zone.today.year, Time.zone.today.month - 1, 10))
    FactoryBot.create(:monthly_fee, student_id: student_two.id, status: 'Paga', due_date: Date.new(Time.zone.today.year, Time.zone.today.month, 10))
    FactoryBot.create(:monthly_fee, student_id: student_two.id, status: 'A pagar', due_date: Date.new(Time.zone.today.year, Time.zone.today.month + 1, 10))
    FactoryBot.create(:monthly_fee, student_id: student_three.id, status: 'Atrasada')
    FactoryBot.create(:monthly_fee, student_id: student_four.id, status: 'Atrasada')
    FactoryBot.create(:monthly_fee, student_id: student_five.id, status: 'Atrasada')

    login_as(admin)
    visit(root_path)
    click_on('Finanças')
    click_on('Pagamentos atrasados')
    click_on('agosto')

    expect(page).to have_content('Mensalidades atrasadas')
    expect(page).to have_content('Charmander')
    expect(page).not_to have_content('Bulbassaur')
    expect(page).not_to have_content('Squirtle')
    expect(page).not_to have_content('Caterpie')
    expect(page).not_to have_content('Gengar')
    
  end
end