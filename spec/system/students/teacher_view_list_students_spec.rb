require 'rails_helper'

RSpec.describe 'User vê listagem de alunos' do
  it 'com sucesso' do
    # arrange
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    user_teacher_two =
      User.create!(
        email: 'clara@admin.com.br',
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
    teacher_two =
      Teacher.create!(
        name: 'Clara',
        status: 'disponível',
        user_id: user_teacher_two.id,
        cpf: '088.088.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom_two =
      Classroom.create!(
        name: 'MW 18:00',
        teacher_id: teacher_two.id,
        time: '18:00'
      )
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
      classroom_id: classroom_two.id,
      cpf: nil
    )
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )
    User.create!(
      email: 'student@email.com',
      password: 'password',
      cpf: '065.654.654-01'
    )

    # act
    login_as(user_teacher)
    visit(root_path)

    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Charmander')
    expect(page).to have_content('Pikachu')
    expect(page).not_to have_content('Blastoise')
    expect(page).to_not have_content('Bulbassaur')
    expect(page).to_not have_content('Você não tem acesso')
  end
end
