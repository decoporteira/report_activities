require 'rails_helper'

RSpec.describe 'Visitante criar um usuário' do
  it 'com sucesso' do
    visit(root_path)
    
    click_on('Criar Conta')
    fill_in 'E-mail', with: 'teste@teste.com'
    fill_in 'cpf', with: '00000000000'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on('Criar conta')

    expect(page).to have_content('Bem vindo! Você realizou seu registro com sucesso.')
  end

  it 'e falha' do
    visit(root_path)

    click_on('Criar Conta')
    fill_in 'E-mail', with: ''
    fill_in 'cpf', with: '00000000000'
    fill_in 'Senha', with: '123456'
    fill_in 'Confirme sua senha', with: '123456'
    click_on('Criar conta')

    expect(page).to have_content('Não foi possível salvar usuário')
    expect(page).to have_content('E-mail não pode ficar em branco')
  end
end
