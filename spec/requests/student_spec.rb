require 'rails_helper'

RSpec.describe 'Students', type: :request do
  context 'Tenta acessar a página de edição de estudantes' do
    it 'e é admin' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                                cpf: '000.097.098-01')
      login_as(user)
      get edit_student_path(student)

      expect(response).to have_http_status :ok
    end

    it 'e é default' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'default')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                                cpf: '000.097.098-01')
      login_as(user)
      get edit_student_path(student)

      expect(response).to redirect_to root_path
    end
  end

  context 'Cria um aluno' do
    it 'com sucesso' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
      teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher_user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student_attributes = { name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                             cpf: '000.097.098-01' }

      login_as(user)

      expect { post students_path, params: { student: student_attributes } }.to change(Student, :count).by(1)
      expect(flash[:notice]).to eq('Student was successfully created.')
    end

    it 'com falha pois não tem permissão' do
      User.create!(email: 'admin@admin.com.br', password: 'password', role: 'teacher')
      teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher_user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student_attributes = { name: '', status: 'Matriculado', classroom_id: classroom.id, cpf: '000.097.098-01' }
      login_as(teacher_user)

      expect { post students_path, params: { student: student_attributes } }.to change(Student, :count).by(0)
      expect(flash[:alert]).to eq('Você não tem permissão para cadastrar novos alunos.')
    end

    it 'e falha por nome do estudante está em branco' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
      teacher_user = User.create!(email: 'teacher@email.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher_user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student_attributes = { name: '', status: 'Matriculado', classroom_id: classroom.id, cpf: '000.097.098-01' }

      login_as(user)

      expect { post students_path, params: { student: student_attributes } }.to change(Student, :count).by(0)
      expect(flash[:alert]).to eq('Failed to create student.')
    end
  end

  context 'Edita um aluno' do
    it 'com sucesso' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'teacher')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student = Student.create!(name: 'Bulbassaur', status: 'Matriculado', classroom_id: classroom.id,
                                cpf: '000.097.098-01')
      login_as(user)
      patch(student_path(student), params: { student: { name: 'Venossaur' } })

      expect(response).to redirect_to student_path(student)
      expect(student.reload.name).to eq 'Venossaur'
    end

    it 'e sucesso' do
      user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
      teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: user.id, cpf: '087.097.098-01')
      classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
      student = Student.create!(name: 'Bulbassaur', status: 'Matriculado', classroom_id: classroom.id,
                                cpf: '000.097.098-01')
      login_as(user)
      patch(student_path(student), params: { student: { name: '' } })

      expect(response).to have_http_status :unprocessable_entity
      expect(student.reload.name).to eq 'Bulbassaur'
    end
  end
end
