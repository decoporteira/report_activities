require 'rails_helper'

RSpec.describe 'Usuário cadastra um responsável financeiro' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(user)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Cadastrar Responsável Financeiro')

    fill_in 'Nome', with: 'Prof. Oak'
    fill_in 'CPF', with: '000.000.000-01'
    fill_in 'Email', with: 'oak@email.com'
    fill_in 'Telefone', with: '3299900-0000'
    click_on 'Salvar'

    expect(page).to have_content('Responsável cadastrado com sucesso.')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Prof. Oak | 3299900-0000')
    expect(page).to have_content('Responsável Financeiro:')
  end

  it 'e falha' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(user)
    visit(root_path)
    click_on('Responsáveis')
    click_on('Cadastrar Responsável Financeiro')
    fill_in 'Nome', with: ''
    fill_in 'CPF', with: '000.000.000-01'
    fill_in 'Email', with: 'oak@email.com'
    fill_in 'Telefone', with: '3299900-0000'
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível cadastrar o Responsável.')
  end
end
