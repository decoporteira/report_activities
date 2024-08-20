require 'rails_helper'

RSpec.describe 'user creates new Address' do
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

    # assert
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('MW 17:00')
    expect(page).to have_content('Rua: Rua das Covas')
    expect(page).to have_content('Número: 23')
    expect(page).to have_content('Complemento: 232')
    expect(page).to have_content('Bairro: Santos Dumont')
    expect(page).to have_content('Cidade: Juiz de Fora')
    expect(page).to have_content('Estado: MG')
    expect(page).to have_content('País: Brasil')
    expect(page).to have_content('CEP: 34050-098')
  end

  it 'fails' do
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
    student_two =
      Student.create!(
        name: 'Venossaur',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '000.000.000-01'
      )
    student =
      Student.create!(
        name: 'Pikachu',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '000.000.000-02'
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
    user_two =
      User.create!(
        email: 'oak@email.com',
        password: 'password',
        role: 'default',
        cpf: '000.000.000-99'
      )
    responsible =
      FinancialResponsible.create!(
        name: 'Oak',
        cpf: '000.000.000-99',
        email: 'oak@email.com',
        phone: '32 0000-0000'
      )
    Responsible.create!(
      student_id: student_two.id,
      financial_responsible_id: responsible.id
    )

    # act
    login_as(user_two)
    visit(root_path)

    # click_on('Ver Atividades')

    # assert
    expect(page).not_to have_content('Pikachu')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('MW 17:00')
  end

  it 'fails' do
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
    student_two =
      Student.create!(
        name: 'Venossaur',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '000.000.000-01'
      )
    student =
      Student.create!(
        name: 'Entei',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '000.000.000-02'
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
    user_two =
      User.create!(
        email: 'oak@email.com',
        password: 'password',
        role: 'default',
        cpf: '000.000.000-01'
      )
    responsible =
      FinancialResponsible.create!(
        name: 'Oak',
        cpf: '000.000.000-01',
        email: 'oak@email.com',
        phone: '32 0000-0000'
      )
    Responsible.create!(
      student_id: student_two.id,
      financial_responsible_id: responsible.id
    )

    # act
    login_as(user_two)
    visit(root_path)
    click_on('Ver Atividades')

    # assert
    expect(page).not_to have_content('Entei')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('MW 17:00')
  end
end
