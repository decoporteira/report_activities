require 'rails_helper'

RSpec.describe 'Tipo de usuário cria uma student' do
  it 'Admin a partir do menu' do
    # arrange
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '17:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')

    # act
    login_as(user)
    visit(root_path)
    click_on 'Students'
    click_on 'Detalhes'
    click_on 'Edit this student'
    fill_in 'Nome', with: 'Bulbassaur'
    click_on 'Atualizar Aluno'

    # assert
    expect(page).to have_content('Student was successfully updated.')
    expect(page).to have_content('Bulbassaur')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 065.654.654-01')
  end

  it 'accounting a partir do menu e falha pois não tem permissão' do
    # arrange
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'accounting')

    # act
    login_as(user)
    visit(root_path)
    click_on 'Students'
    click_on 'Detalhes'
    click_on 'Edit this student'
    fill_in 'Nome', with: 'Bulbassaur'
    click_on 'Atualizar Aluno'

    # assert
    expect(page).to have_content('Student was successfully updated.')
    expect(page).to have_content('Bulbassaur')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 065.654.654-01')
  end

  it 'Teacher a partir do menu e falha pois não tem permissão' do
    # arrange
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')

    # act
    login_as(user_teacher)
    visit(root_path)
    click_on 'Students'

    # assert
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Turma: MW 17:00')
  end
  it 'a partir do menu e falha pois não tem permissão' do
    # arrange
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'default', cpf: '065.654.654-01')

    # act
    login_as(user)
    visit(root_path)

    # assert
    expect(page).not_to have_content('Detalhes')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Turma: MW 17:00')
  end
end
