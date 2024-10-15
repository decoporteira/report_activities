require 'rails_helper'

RSpec.describe 'Usuário cadastra um Plano a partir da home' do
  it 'com sucesso' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:plan, name: 'Teens', price: 350)

    login_as(user)
    visit(plans_path)

    expect(page).to have_content('Kids')
    expect(page).to have_content('Valor: R$ 330,00')
  end
  it 'e falha, pois não tem acesso' do
    user = FactoryBot.create(:user, role: 'default')
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:plan, name: 'Teens', price: 350)

    login_as(user)
    visit(plans_path)

    expect(page).to have_content('Você não possui acesso.')
    expect(page).not_to have_content('Kids')
    expect(page).not_to have_content('Valor: R$ 330,00')
  end
end
