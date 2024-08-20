require 'rails_helper'

RSpec.describe 'User vê total de alunos' do
  it 'logado como admin' do
    # arrange
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
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
      cpf: '000.097.098-01'
    )
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )

    # act
    login_as(user)
    visit(root_path)

    # assert
    expect(page).to have_content('Total de alunos matriculados: 1')
  end

  it 'logado como teacher' do
    # arrange
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
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
      cpf: '000.097.098-01'
    )
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )

    # act
    login_as(user_teacher)
    visit(root_path)

    # assert
    expect(page).to_not have_content('Total de alunos matriculados: 1')
  end

  it 'logado como default' do
    # arrange
    teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: teacher.id,
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
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )
    user_student =
      User.create!(
        email: 'student@email.com',
        password: 'password',
        cpf: '065.654.654-01'
      )

    # act
    login_as(user_student)
    visit(root_path)

    # assert
    expect(page).to_not have_content('Total de alunos matriculados:')
  end
end
