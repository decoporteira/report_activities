require 'rails_helper'

RSpec.describe 'User cria uma student' do
    it 'a partir do menu' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
       
        #act
        login_as(user)
        visit(root_path)
        click_on 'Students'
        click_on 'New student'
        fill_in 'Name', with: 'Charizard'
        fill_in 'student_cpf', with: '000.000.000-01'
        select 'Matriculado', from: 'student_status'
        select 'MW 17:00', from: 'student_classroom_id'
        click_on 'Create Student'
        
        #assert
        expect(page).to have_content('Student was successfully created.')
        expect(page).to have_content('Charizard')
        expect(page).to have_content('Professor(a): Bianca')
        expect(page).to have_content('Turma: MW 17:00')
        expect(page).to have_content('CPF: 000.000.000-01')


    end
end