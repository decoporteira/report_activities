require 'rails_helper'

RSpec.describe 'User vê listagem de alunos' do
  it 'com sucesso' do
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                              cpf: '065.654.654-01')
    Student.create!(name: 'Charmander', status: 'Matriculado', classroom_id: classroom.id, cpf: '077.654.654-01')
    Student.create!(name: 'Blastoise', status: 'Não matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    Student.create!(name: 'Pikachu', status: 'Matriculado', classroom_id: classroom.id, cpf: '')
    Student.create!(name: 'Bulbassaur', status: 'Matriculado', classroom_id: classroom.id, cpf: nil)
    User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_student = User.create!(email: 'student@email.com', password: 'password', cpf: '065.654.654-01')

    login_as(user_student)
    visit(report_student_path(student))

    expect(page).to have_content('Venossaur')
    expect(page).not_to have_content('Blastoise')
    expect(page).to_not have_content('Charmander')
    expect(page).to_not have_content('Pikachu')
    expect(page).to_not have_content('Você não tem acesso')
  end

  it 'e falha por não ter acesso ao aluno' do
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student = Student.create!(name: 'Charmander', status: 'Matriculado', classroom_id: classroom.id,
                              cpf: '077.654.654-01')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    Student.create!(name: 'Blastoise', status: 'Não matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    Student.create!(name: 'Pikachu', status: 'Matriculado', classroom_id: classroom.id, cpf: '')
    Student.create!(name: 'Bulbassaur', status: 'Matriculado', classroom_id: classroom.id, cpf: nil)
    User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_default = User.create!(email: 'default@email.com', password: 'password', cpf: '065.654.654-01')

    login_as(user_default)
    visit(report_student_path(student))

    expect(page).to have_content('Você não possui acesso a esse aluno.')
  end
end
