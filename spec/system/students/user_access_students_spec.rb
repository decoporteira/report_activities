require 'rails_helper'

RSpec.describe 'User vê alunos' do
    it 'Usando o cpf certo' do
        #arrange
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
        Student.create!(name: 'Charmander', status: 'Matriculado', classroom_id: classroom.id, cpf: '077.654.654-01')
        Student.create!(name: 'Blastoise', status: 'Não matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
        User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_student = User.create!(email: 'student@email.com', password: 'password', cpf: '065.654.654-01', )

        #act
        login_as(user_student)
        visit(student_path(student))

        expect(page).to have_content('Venossaur')
        expect(page).to have_content('Relatório de 2024')
    end
    it 'Usando o cpf errado' do
        #arrange
        user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher' )
        teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id, cpf: '087.097.098-01' )
        classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
        Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
        studentTwo = Student.create!(name: 'Charmander', status: 'Matriculado', classroom_id: classroom.id, cpf: '077.654.654-01')
        Student.create!(name: 'Blastoise', status: 'Não matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
        User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin' )
        user_student = User.create!(email: 'student@email.com', password: 'password', cpf: '065.654.654-01', )

        #act
        login_as(user_student)
        visit(student_path(studentTwo))

        expect(page).to have_content('Você não possui acesso')
        expect(page).to have_content('Blastoise')
        expect(page).to have_content('Venossaur')
        expect(page).to_not have_content('Charmander')
        expect(page).to_not have_content('Relatório de 2024')
    end
end