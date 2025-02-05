require 'rails_helper'

RSpec.describe 'User sees fees list' do
  it 'com sucesso' do
    accounting = FactoryBot.create(:user, role: 'accounting')
    student_one = FactoryBot.create(:student, name: 'Charmander')
    student_two = FactoryBot.create(:student, name: 'Bulbassaur')
    FactoryBot.create(:student, name: 'Squirtle')

    MonthlyFee.create!(
      student_id: student_one.id,
      due_date: '2025-04-04',
      value: 300,
      status: 'Paga'
    )
    MonthlyFee.create!(
      student_id: student_two.id,
      due_date: '2025-04-04',
      value: 300,
      status: 'Paga'
    )

    login_as(accounting)
    visit(root_path)
    click_on('Mensalidades')

    expect(page).to have_content('Charmander')
    expect(page).to have_content('Bulbassaur')
    expect(page).not_to have_content('Squirtle')
    expect(page).to have_content('R$ 300')
  end
end
