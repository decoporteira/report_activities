require 'rails_helper'

RSpec.describe 'user edit address' do
  it 'sucess' do
    # arrange
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student =
      Student.create!(
        name: 'Venossaur',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '000.097.098-01'
      )
    Address.create!(
      street: 'Rua das Covas',
      number: '23',
      unit: '232',
      neighborhood: 'Santos Dumont',
      city: 'Juiz de Fora',
      state: 'MG',
      country: 'Brasil',
      zip_code: '34050-098',
      addressable_id: student.id,
      addressable_type: 'Student'
    )

    # act
    login_as(user)
    visit(root_path)
    find('#details').click
    click_on('Editar Endereço')
    fill_in 'Rua', with: 'Rua dos Alfaces'
    click_on('Atualizar Endereço')

    # assert
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Rua dos Alfaces')
    expect(page).to have_content('Número: 23')
    expect(page).to have_content('Complemento: 232')
    expect(page).to have_content('Bairro: Santos Dumont')
    expect(page).to have_content('Cidade: Juiz de Fora')
    expect(page).to have_content('Estado: MG')
    expect(page).to have_content('País: Brasil')
    expect(page).to have_content('CEP: 34050-098')
  end

  it 'Editar endereço de professor' do
    # arrange
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.097.098-01'
    )
    Address.create!(
      street: 'Rua das Covas',
      number: '23',
      unit: '232',
      neighborhood: 'Santos Dumont',
      city: 'Juiz de Fora',
      state: 'MG',
      country: 'Brasil',
      zip_code: '34050-098',
      addressable_id: teacher.id,
      addressable_type: 'Teacher'
    )

    # act
    login_as(user)
    visit(root_path)
    click_on('Professores')
    click_on('Show this teacher')
    click_on('Editar')
    fill_in 'Rua', with: 'Rua dos Alfaces'
    click_on('Atualizar Endereço')

    # assert
    expect(page).to have_content('Bianca')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Rua dos Alfaces')
    expect(page).to have_content('Número: 23')
    expect(page).to have_content('Complemento: 232')
    expect(page).to have_content('Bairro: Santos Dumont')
    expect(page).to have_content('Cidade: Juiz de Fora')
    expect(page).to have_content('Estado: MG')
    expect(page).to have_content('País: Brasil')
    expect(page).to have_content('CEP: 34050-098')
  end

  it 'Editar endereço de professor e falha' do
    # arrange
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '000.097.098-01'
    )
    Address.create!(
      street: 'Rua das Covas',
      number: '23',
      unit: '232',
      neighborhood: 'Santos Dumont',
      city: 'Juiz de Fora',
      state: 'MG',
      country: 'Brasil',
      zip_code: '34050-098',
      addressable_id: teacher.id,
      addressable_type: 'Teacher'
    )

    # act
    login_as(user)
    visit(root_path)
    click_on('Professores')
    click_on('Show this teacher')
    click_on('Editar')
    fill_in 'Rua', with: 'Rua dos Alfaces'
    click_on('Atualizar Endereço')

    # assert
    expect(page).to have_content('Bianca')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Rua dos Alfaces')
    expect(page).to have_content('Número: 23')
    expect(page).to have_content('Complemento: 232')
    expect(page).to have_content('Bairro: Santos Dumont')
    expect(page).to have_content('Cidade: Juiz de Fora')
    expect(page).to have_content('Estado: MG')
    expect(page).to have_content('País: Brasil')
    expect(page).to have_content('CEP: 34050-098')
  end
end
