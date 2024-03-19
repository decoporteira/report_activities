require 'rails_helper'

RSpec.describe 'Admin edita classroom' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher.id, cpf: '087.097.098-01')
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    login_as(user)
    visit(root_path)
    click_on 'Ver turma'
    click_on 'Edit this classroom'
    fill_in 'Nome', with: 'Sala dos Pokemon'
    click_on 'Atualizar Turma'

    expect(page).to have_content('Turma Sala dos Pokemon')
    expect(page).to have_content('Turma editada com sucesso.')
  end
  it 'e falha' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher.id, cpf: '087.097.098-01')
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    login_as(user)
    visit(root_path)
    click_on 'Ver turma'
    click_on 'Edit this classroom'
    fill_in 'Nome', with: ''
    click_on 'Atualizar Turma'

    expect(page).to have_content('Nome não pode ficar em branco')
  end
end
