require 'rails_helper'

RSpec.describe 'Usuário editar Responsável financeiro' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    financial_responsible = FinancialResponsible.create!(name: 'Oak', cpf: '000.000.000-00', email: 'oak@gmail.com',
                                                         phone: '00 0000-0000')

    login_as(user)
    visit financial_responsible_path(financial_responsible)
    click_on('Editar')
    fill_in 'Name', with: 'Prof. Cherry'
    fill_in 'Cpf', with: '000.000.000-02'
    fill_in 'Email', with: 'Cherry@email.com'
    fill_in 'Phone', with: '00 0000-0002'
    click_on 'Salvar'

    expect(page).to have_content('Responsável editado com sucesso.')
    expect(page).to have_content('Prof. Cherry')
    expect(page).to have_content('000.000.000-02')
    expect(page).to have_content('Cherry@email.com')
    expect(page).to have_content('00 0000-0002')
    expect(page).not_to have_content('Oak')
  end
end
