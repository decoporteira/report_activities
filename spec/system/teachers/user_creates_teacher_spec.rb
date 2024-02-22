require 'rails_helper'

RSpec.describe 'Tipo de usuário cria uma student' do
  context 'a partir do menu' do
    it 'Admin a partir do menu com sucesso' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')

      # act
      login_as(user)
      visit(root_path)
      click_on 'Teachers'
      click_on 'New teacher'

      fill_in 'Nome', with: 'Carvalho'
      fill_in 'cpf', with: '000.000.000-01'
      select 'teacher@email.com.br', from: 'Usuário'

      select 'Disponível', from: 'Disponibilidade'
      click_on 'Criar Professor(a)'

      # assert
      expect(page).to have_content('Teacher was successfully created.')
      expect(page).to have_content('Name: Carvalho')
      expect(page).to have_content('Status: disponível')
      expect(page).to have_content('CPF: 000.000.000-01')
    end
    it 'accounting a partir do menu e falha pois não tem permissão' do
      # arrange
      accounting = User.create!(email: 'admin@email.com.br', password: 'password', role: 'accounting')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(accounting)
      visit(root_path)
      click_on 'Teachers'
      click_on 'New teacher'

      fill_in 'Nome', with: 'Carvalho'
      fill_in 'cpf', with: '000.000.000-01'
      select 'teacher@email.com.br', from: 'Usuário'

      select 'Disponível', from: 'Disponibilidade'
      click_on 'Criar Professor(a)'

      # assert
      expect(page).to have_content('Teacher was successfully created.')
      expect(page).to have_content('Name: Carvalho')
      expect(page).to have_content('Status: disponível')
      expect(page).to have_content('CPF: 000.000.000-01')
    end
    it 'teacher a partir do menu e falha pois não tem permissão' do
      # arrange
      # arrange
      User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(teacher)
      visit(root_path)

      # assert
      expect(page).not_to have_content('Teachers')
      expect(page).not_to have_content('New Teacher')
    end
    it 'Default a partir do menu e falha pois não tem permissão' do
      # arrange
      user = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

      # act
      login_as(user)
      visit(root_path)

      # assert
      expect(page).not_to have_content('Teachers')
      expect(page).not_to have_content('New Teacher')
    end
  end

  context 'direto no link dos professores' do
    it 'Admin direto pelo link de edição' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')

      # act
      login_as(user)
      visit(teachers_path)
      click_on 'New teacher'

      fill_in 'Nome', with: 'Carvalho'
      fill_in 'cpf', with: '000.000.000-01'
      select 'teacher@email.com.br', from: 'Usuário'

      select 'Disponível', from: 'Disponibilidade'
      click_on 'Criar Professor(a)'

      # assert
      expect(page).to have_content('Teacher was successfully created.')
      expect(page).to have_content('Name: Carvalho')
      expect(page).to have_content('Status: disponível')
      expect(page).to have_content('CPF: 000.000.000-01')
    end
    it 'Accounting direto pelo link de edição' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'accounting')
      User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')

      # act
      login_as(user)
      visit(teachers_path)
      click_on 'New teacher'

      fill_in 'Nome', with: 'Carvalho'
      fill_in 'cpf', with: '000.000.000-01'
      select 'teacher@email.com.br', from: 'Usuário'

      select 'Disponível', from: 'Disponibilidade'
      click_on 'Criar Professor(a)'

      # assert
      expect(page).to have_content('Teacher was successfully created.')
      expect(page).to have_content('Name: Carvalho')
      expect(page).to have_content('Status: disponível')
      expect(page).to have_content('CPF: 000.000.000-01')
    end
    it 'teacher a partir do menu e falha pois não tem permissão' do
      # arrange
      # arrange
      User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(teacher)
      visit(teachers_path)

      # assert
      expect(page).to have_content('Access denied')
      expect(current_path).to eq root_path
      expect(page).not_to have_content('Teachers')
      expect(page).not_to have_content('New Teacher')
    end
    it 'Default a partir do menu e falha pois não tem permissão' do
      # arrange
      user = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

      # act
      login_as(user)
      visit(teachers_path)

      # assert
      expect(page).to have_content('Access denied')
      expect(current_path).to eq root_path
      expect(page).not_to have_content('Teachers')
      expect(page).not_to have_content('New Teacher')
    end
  end
end
