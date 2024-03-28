require 'rails_helper'

RSpec.describe 'Usuário loga no sistema' do
  it 'com sucesso' do
    User.create!(email: 'teste@email.com', password: 'password')

    visit(root_path)
    fill_in 'E-mail', with: 'teste@email.com'
    fill_in 'Senha', with: 'password'
    click_on('Entrar')

    expect(page).to have_content('Login efetuado com sucesso.')
  end
end
