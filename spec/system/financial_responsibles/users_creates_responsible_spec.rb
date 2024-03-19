require 'rails_helper'

RSpec.describe 'Usuário cria um responsável financeiro' do
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
    click_on('Responsáveis')
    click_on('Cadastrar Responsável Financeiro')
    fill_in 'Name', with: 'Prof. Oak'
    fill_in 'Cpf', with: '000.000.000-01'
    fill_in 'Email', with: 'oak@email.com'
    fill_in 'Phone', with: '3299900-0000'
    click_on 'Cadastrar'

    expect(page).to have_content('Responsável cadastrado com sucesso.')

  end
end
