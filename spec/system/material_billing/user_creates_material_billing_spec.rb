require 'rails_helper'

RSpec.describe 'User creates new material billing' do
  it 'com sucesso' do
    admin = User.create!(email: 'admin@email.com', password: '123456', role: :admin)

    login_as admin
    visit(root_path)

    click_on 'Cobranças Extras'
    click_on 'New material billing'
    fill_in 'Name', with: 'Livro Advanced'
    select 'Pago', from: 'Status'
    fill_in 'Date', with: Time.zone.today
    click_on 'Criar Material billing'

    expect(page).to have_content 'Nome: Livro Advanced'
    expect(page).to have_content 'Status: Pago'
  end
end
