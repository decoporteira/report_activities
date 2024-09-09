require 'rails_helper'

RSpec.describe 'Usuário vê detalhes de Responsável' do
  it 'com sucesso' do
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    student = create(:student)
    responsible =
      FinancialResponsible.create!(
        name: 'Oak',
        cpf: '000.000.000-00',
        email: 'oak@gmail.com',
        phone: '00 0000-0000'
      )
    FinancialResponsible.create!(
      name: 'Joy',
      cpf: '000.000.000-01',
      email: 'joy@gmail.com',
      phone: '00 0000-0001'
    )
    FinancialResponsible.create!(
      name: 'James',
      cpf: '000.000.000-02',
      email: 'james@gmail.com',
      phone: '00 0000-0002'
    )
    Responsible.create!(
      student_id: student.id,
      financial_responsible_id: responsible.id
    )

    login_as(user)
    visit(financial_responsibles_path)
    click_on 'Oak'

    expect(Responsible.count).to eq 1
    expect(page).to have_content('Oak')
    expect(page).to have_content('000.000.000-00')
    expect(page).to have_content('oak@gmail.com')
    expect(page).to have_content('00 0000-0000')
    expect(page).to have_content('Jon Doe6')
    expect(page).not_to have_content('Joy')
    expect(page).not_to have_content('James')
    expect(page).not_to have_content('000.000.000-01')
    expect(page).not_to have_content('000.000.000-02')
  end
end
