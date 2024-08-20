require 'rails_helper'

RSpec.describe 'User vê listagem de alunos' do
  it 'com sucesso' do
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student =
      Student.create!(
        name: 'Venossaur',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '065.654.654-01'
      )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    student_two =
      Student.create!(
        name: 'Blastoise',
        status: :not_registered,
        classroom_id: classroom.id,
        cpf: '065.654.654-01'
      )
    Student.create!(
      name: 'Pikachu',
      status: :registered,
      classroom_id: classroom.id,
      cpf: ''
    )
    Student.create!(
      name: 'Bulbassaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: nil
    )
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )
    user_student =
      User.create!(
        email: 'oak@email.com',
        password: 'password',
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
      student_id: student.id,
      financial_responsible_id: responsible.id
    )
    Responsible.create!(
      student_id: student_two.id,
      financial_responsible_id: responsible.id
    )

    # act
    login_as(user_student)
    visit(root_path)

    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Blastoise')

    expect(page).to_not have_content('Charmander')
    expect(page).to_not have_content('Pikachu')
    expect(page).to_not have_content('Você não tem acesso')
  end

  it 'e falha, por não digitar um cpf' do
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: ''
    )
    Student.create!(
      name: 'Blastoise',
      status: :not_registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    Student.create!(
      name: 'Pikachu',
      status: :registered,
      classroom_id: classroom.id,
      cpf: ''
    )
    Student.create!(
      name: 'Bulbassaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: nil
    )
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )
    user_student =
      User.create!(email: 'student@email.com', password: 'password', cpf: '')

    # act
    login_as(user_student)
    visit(root_path)

    expect(page).to_not have_content('Blastoise')
    expect(page).to_not have_content('Venossaur')
    expect(page).to_not have_content('Charmander')
    expect(page).to_not have_content('Pikachu')
    expect(page).to_not have_content('Bulbassaur')
    expect(page).to have_content('Sem alunos para mostrar.')
  end
end
