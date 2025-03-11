require 'rails_helper'

RSpec.describe 'User creates new material billing' do
  it 'com sucesso' do
    admin = User.create!(email: 'admin@email.com', password: '123456', role: :admin)
    Student.create(name: 'Pikachu', status: :registered)
    login_as admin
    visit(root_path)

    click_on 'Cobranças Extras'
    click_on 'Nova cobrança'
    fill_in 'Descrição', with: 'Livro Advanced'
    select 'Pago', from: 'Status'
    select 'Pikachu', from: 'Aluno'
    fill_in 'Data', with: Time.zone.today
    fill_in 'Valor', with: 240
    click_on 'Criar cobrança'

    expect(page).to have_content 'Detalhe: Livro Advanced'
    expect(page).to have_content 'Status: Pago'
  end
end
