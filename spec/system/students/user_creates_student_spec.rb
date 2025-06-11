require 'rails_helper'

RSpec.describe 'Tipo de usuário cria uma student' do
  it 'Admin a partir do menu', type: :system, js: true do
    # arrange
    Plan.create!(name: 'Kids', price: 123, id: 1)
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
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'
    click_on 'New student'

    fill_in 'Nome', with: 'Onix'
    fill_in 'cpf', with: '000.000.000-01'
    select 'Kids', from: 'student_plan_id'
    select 'Matriculado', from: 'student_status'
    select 'MW 17:00', from: 'student[classroom_id]'
    click_on 'Criar Aluno'

    # assert
    expect(page).to have_content('Aluno(a) criado(a) com sucesso.')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 000.000.000-01')
  end

  it 'accounting a partir do menu e falha pois não tem permissão' do
    # arrange
    user =
      User.create!(
        email: 'accounting@admin.com.br',
        password: 'password',
        role: 'accounting'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'
    click_on 'New student'
    fill_in 'Nome', with: 'Onix'
    fill_in 'cpf', with: '000.000.000-01'
    select 'Matriculado', from: 'student_status'
    select 'MW 17:00', from: 'student_classroom_id'
    click_on 'Criar Aluno'

    # assert
    expect(page).to have_content('Aluno(a) criado(a) com sucesso.')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 000.000.000-01')
  end
  it 'a partir do menu e falha pois não tem permissão' do
    # arrange
    user =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'

    # assert
    expect(page).not_to have_content('New student')
  end
  it 'a partir do menu e falha pois não tem permissão' do
    # arrange
    user =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user.id,
        cpf: '087.097.098-01'
      )
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    # act
    login_as(user)
    visit(root_path)

    # assert
    expect(page).not_to have_content('New student')
  end
end
