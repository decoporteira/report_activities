require 'rails_helper'

RSpec.describe 'User sees fees list' do
  it 'com sucesso' do
    accounting = FactoryBot.create(:user, role: 'accounting')
    student_one = FactoryBot.create(:student, name: 'Charmander')
    student_two = FactoryBot.create(:student, name: 'Bulbassaur')
    FactoryBot.create(:student, name: 'Squirtle')
    plan = Plan.create!(name: 'Kids', price: 300, billing_type: 'monthly')
    CurrentPlan.create(student_id: student_one.id, plan_id: plan.id, has_discount: false, discount: 0)
    CurrentPlan.create(student_id: student_two.id, plan_id: plan.id)

    MonthlyFee.create!(
      student_id: student_one.id,
      due_date: '2025-08-08',
      value: 300,
      status: 'Paga'
    )
    MonthlyFee.create!(
      student_id: student_two.id,
      due_date: '2025-08-08',
      value: 300,
      status: 'Paga'
    )

    login_as(accounting)
    visit(root_path)
    click_on('Mensalidades')

    expect(page).to have_content('Charmander')
    expect(page).to have_content('Bulbassaur')
    expect(page).not_to have_content('Squirtle')
    expect(page).to have_content('300,00')
  end
end
