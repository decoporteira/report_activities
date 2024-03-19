require 'rails_helper'

RSpec.describe 'user creates new Address' do
  it 'e cria um endereço para um aluno' do
    # arrange
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '000.097.098-01')

    # act
    login_as(user)
    visit(root_path)
    find('#details').click
    click_on('Cadastrar Endereço')
    within('#new_address_form') do
      fill_in 'Rua', with: 'Rua das Coves'
      fill_in 'Número', with: '23'
      fill_in 'Complemento', with: 'apto 203'
      fill_in 'Bairro', with: 'Santos Dumont'
      fill_in 'Cidade', with: 'Juiz de Fora'
      fill_in 'Estado', with: 'MG'
      fill_in 'País', with: 'Brasil'
      fill_in 'CEP', with: '36038-030'
      click_on('Criar Endereço')
    end
    # #assert
    expect(page).not_to have_content('Charizard')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Endereço criado com sucesso.')
  end

  it 'criar um endereço para um professor' do
    # arrange
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    # act
    login_as(user)
    visit(root_path)

    click_on('Professores')
    click_on('Show this teacher')
    click_on('Cadastrar Endereço')
    within('#new_address_form') do
      fill_in 'Rua', with: 'Rua das Coves'
      fill_in 'Número', with: '23'
      fill_in 'Complemento', with: 'apto 203'
      fill_in 'Bairro', with: 'Santos Dumont'
      fill_in 'Cidade', with: 'Juiz de Fora'
      fill_in 'Estado', with: 'MG'
      fill_in 'País', with: 'Brasil'
      fill_in 'CEP', with: '36038-030'
      click_on('Criar Endereço')
    end
    # #assert
    expect(page).to have_content('Bianca')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Endereço criado com sucesso.')
    expect(page).to have_content('Rua das Coves')
  end
end
