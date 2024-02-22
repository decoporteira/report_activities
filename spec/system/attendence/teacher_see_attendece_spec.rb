require 'rails_helper'

RSpec.describe 'Teacher ve lista de presença' do
    it 'a partir do menu' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

        login_as(user)
        visit(root_path)
        click_on 'Attendances'

        expect(page).to have_content('Lista de Presença')

    end

    it 'e está presente' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        student = Student.create!(name: 'Ratata', classroom_id: classroom.id, status: 'Matriculado')
        Attendance.create!(presence: true, attendance_date: '2023-05-05', student_id: student.id)
        login_as(user)
        visit(root_path)
        click_on 'Attendances'
        click_on 'Ratata'

        expect(page).to have_content('Relatório de presença de Ratata')
        expect(page).to have_content('Ratata')
        expect(page).to have_content('05/05/23: Presente')
    end

    it 'e está ausente' do
        #arrange
        user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        student = Student.create!(name: 'Raticate', classroom_id: classroom.id, status: 'Matriculado')
        Attendance.create!(presence: false, attendance_date: '2023-05-05', student_id: student.id)
        login_as(user)
        visit(root_path)
        click_on 'Attendances'
        click_on 'Raticate'

        expect(page).to have_content('Relatório de presença de Raticate')
        expect(page).to have_content('Raticate')
        expect(page).to have_content('05/05/23: Ausente')
    end
end
