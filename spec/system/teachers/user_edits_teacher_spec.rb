require 'rails_helper'

RSpec.describe 'Usuário editar professor' do
  it 'e é admin' do
    admin = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)

    login_as(admin)
    visit root_path
    click_on 'Teachers'
    click_on 'Show this teacher'
    click_on 'Edit this teacher'
    fill_in 'Nome', with: 'Oak'
    fill_in 'cpf', with: '000.000.000-00'
    click_on 'Atualizar Professor(a)'

    expect(page).to have_content 'Teacher was successfully updated.'
    expect(page).to have_content 'Professor(a): Oak'
    expect(page).to have_content 'CPF: 000.000.000-00'
  end

  it 'e é admin mas não preenche todos os campos' do
    admin = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)

    login_as(admin)
    visit root_path
    click_on 'Teachers'
    click_on 'Show this teacher'
    click_on 'Edit this teacher'
    fill_in 'Nome', with: ''
    fill_in 'cpf', with: '000.000.000-00'
    click_on 'Atualizar Professor(a)'

    expect(page).to have_content 'Nome não pode ficar em branco'
  end

  it 'e é accounting' do
    accouting = User.create!(email: 'admin@email.com.br', password: 'password', role: 'accounting')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)

    login_as(accouting)
    visit root_path
    click_on 'Teachers'
    click_on 'Show this teacher'
    click_on 'Edit this teacher'
    fill_in 'Nome', with: 'Oak'
    fill_in 'cpf', with: '000.000.000-00'
    click_on 'Atualizar Professor(a)'

    expect(page).to have_content 'Teacher was successfully updated.'
    expect(page).to have_content 'Professor(a): Oak'
    expect(page).to have_content 'CPF: 000.000.000-00'
  end

  it 'e é teacher' do
    User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)

    login_as(teacher_user)
    visit root_path

    expect(page).not_to have_content 'Teachers'
  end

  it 'e é default' do
    default = User.create!(email: 'admin@email.com.br', password: 'password', role: 'default')
    teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
    Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher_user)

    login_as(default)
    visit root_path

    expect(page).not_to have_content 'Teachers'
  end
end
