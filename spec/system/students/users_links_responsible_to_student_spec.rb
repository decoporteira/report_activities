require 'rails_helper'

RSpec.describe 'Usuário linka responsável financeiro' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')
    FinancialResponsible.create!(name: 'Carvalho', cpf: '000.000.000-01', email: 'carvalho@gmail.com', phone: '32 0000-0000')
    FinancialResponsible.create!(name: 'Joy', cpf: '000.000.000-02', email: 'joy@gmail.com', phone: '33 0000-0000')

    login_as(user)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Vincular Responsável Financeiro Existente')
    select 'Joy', from: 'financial_responsible_id'
    click_on('Salvar')

    expect(page).to have_content('Responsável vinculado com sucesso.')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Nome: Joy | Telefone: 33 0000-0000')
    expect(page).to have_content('Responsável Financeiro')
  end

  it 'e falha' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    #Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')

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

  it 'e falha pois cpf foi duplicado' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
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
