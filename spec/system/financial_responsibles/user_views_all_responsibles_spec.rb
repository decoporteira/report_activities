require 'rails_helper'

RSpec.describe 'Usuário ve todos os resposáveis financeiros' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    FinancialResponsible.create!(name: 'Oak', cpf: '000.000.000-00', email: 'oak@gmail.com', phone: '00 0000-0000')
    FinancialResponsible.create!(name: 'Joy', cpf: '000.000.000-01', email: 'joy@gmail.com', phone: '00 0000-0001')
    FinancialResponsible.create!(name: 'James', cpf: '000.000.000-02', email: 'james@gmail.com', phone: '00 0000-0002')

    login_as(user)
    visit(financial_responsibles_path)
    expect(page).to have_content('Oak')
    expect(page).to have_content('Joy')
    expect(page).to have_content('James')
    expect(page).to have_content('000.000.000-00')
    expect(page).to have_content('oak@gmail.com')
    expect(page).to have_content('00 0000-0000')
    expect(page).to have_content('000.000.000-01')
    expect(page).to have_content('000.000.000-02')
  end
end
