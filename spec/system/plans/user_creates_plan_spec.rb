require 'rails_helper'

RSpec.describe 'Usuário cadastra um Plano a partir da home' do
  it 'com sucesso' do
    user = FactoryBot.create(:user)

    login_as(user)
    visit(root_path)
    click_on('Finanças')
    click_on('Cursos')
    click_on('New plan')
    fill_in 'Nome', with: 'Kids'
    fill_in 'Valor', with: 330
    click_on 'Criar Plan'

    expect(page).to have_content('Plano criado com sucesso.')
    expect(page).to have_content('Nome do plano: Kids')
    expect(page).to have_content('Valor da mensalidade: R$ 330,00')

  end
  it 'e falha, pois não tem acesso' do
    user = FactoryBot.create(:user, role: 'default')

    login_as(user)
    visit(root_path)

    expect(page).not_to have_content('Finanças')
    expect(page).not_to have_content('Cursos')
  end
end
