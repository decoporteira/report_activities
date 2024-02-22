# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tipo de usuário cria uma turma' do
  context 'a partir do menu' do
    it 'como user Admin' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher, status: 'disponível')

      # act
      login_as(user)
      visit(root_path)
      click_on 'ClassRooms'
      click_on 'New classroom'
      fill_in 'Nome', with: 'Sala de Aula'
      fill_in 'Horário', with: '16:00'
      select 'Carvalho', from: 'classroom_teacher_id'
      click_on 'Criar Turma'

      # assert
      expect(page).to have_content('Classroom was successfully created.')
      expect(page).to have_content('Turma Sala de Aula')
      expect(page).to have_content('Carvalho | 16:00')
    end
    it 'e falha' do
        # arrange
        user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
        teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
        Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher, status: 'disponível')
  
        # act
        login_as(user)
        visit(new_classroom_path)
        fill_in 'Nome', with: ''
        fill_in 'Horário', with: '16:00'
        select 'Carvalho', from: 'classroom_teacher_id'
        click_on 'Criar Turma'
  
        # assert
        expect(Classroom.count).to eq 0
        expect(page).to have_content('Nome não pode ficar em branco')
        #expect(current_path).to eq new_classroom_path
      end
    it 'como user accounting' do
      # arrange
      accounting = User.create!(email: 'admin@email.com.br', password: 'password', role: 'accounting')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher, status: 'disponível')

      # act
      login_as(accounting)
      visit(root_path)

      # assert
      expect(page).not_to have_content('ClassRooms')
    end
    it 'como user teacher' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(teacher)
      visit(root_path)
      click_on 'ClassRooms'

      # assert
      expect(page).not_to have_content('Criar Turma')
    end
    it 'como user default' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'default')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(user)
      visit(root_path)

      # assert
      expect(page).not_to have_content('ClassRooms')
    end
  end

  context 'direto no link dos professores' do
    it 'Admin direto pelo link de edição' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher, status: 'disponível')

      # act
      login_as(user)
      visit(new_classroom_path)

      click_on 'ClassRooms'
      click_on 'New classroom'
      fill_in 'Nome', with: 'Sala de Aula'
      fill_in 'Horário', with: '16:00'
      select 'Carvalho', from: 'classroom_teacher_id'
      click_on 'Criar Turma'

      # assert
      expect(page).to have_content('Classroom was successfully created.')
      expect(page).to have_content('Turma Sala de Aula')
      expect(page).to have_content('Carvalho | 16:00')
    end
    it 'Accounting direto pelo link de criação' do
      # arrange
      accounting = User.create!(email: 'admin@email.com.br', password: 'password', role: 'accounting')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')

      # act
      # act
      login_as(accounting)
      visit(new_classroom_path)

      # assert
      expect(page).to have_content('Access denied')
      expect(current_path).to eq root_path
    end

    it 'teacher a partir do menu e falha pois não tem permissão' do
      # arrange
      user = User.create!(email: 'admin@email.com.br', password: 'password', role: 'admin')
      teacher = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      Teacher.create!(name: 'Carvalho', cpf: '000.000.000-01', user: teacher)
      # act
      login_as(teacher)
      visit(new_classroom_path)

      # assert
      expect(page).to have_content('Access denied')
      expect(current_path).to eq root_path
      expect(page).not_to have_content('Teachers')
      expect(page).not_to have_content('New Teacher')
    end

    it 'Default a partir do menu e falha pois não tem permissão' do
      # arrange
      user = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'accounting')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

      # act
      login_as(user)
      visit(new_classroom_path)

      # assert
      expect(page).to have_content('Access denied')
      expect(current_path).to eq root_path
    end
  end
end
