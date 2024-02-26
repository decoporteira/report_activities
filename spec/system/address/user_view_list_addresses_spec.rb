require 'rails_helper'

RSpec.describe 'User vê listagem de alunos' do
  it 'com sucesso' do
    # arrange
    admin = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'clara@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Carvalho', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    classroom_two = Classroom.create!(name: 'MW 18:00', teacher_id: teacher.id, time: '18:00')
    student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                              cpf: '065.654.654-01')
    Student.create!(name: 'Charmander', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '077.654.654-01')
    Student.create!(name: 'Blastoise', status: 'Não matriculado', classroom_id: classroom.id, cpf: '065.654.654-01')
    Student.create!(name: 'Pikachu', status: 'Matriculado', classroom_id: classroom.id, cpf: '')
    Student.create!(name: 'Bulbassaur', status: 'Matriculado', classroom_id: classroom_two.id, cpf: nil)
    Address.create!(street: 'Rua das Covas', number: '23', unit: '232', neighborhood: 'Santos Dumont',
                    city: 'Juiz de Fora', state: 'MG', country: 'Brasil', zip_code: '34050-098',
                    addressable_id: teacher.id, addressable_type: 'Teacher')
    Address.create!(street: 'Rua das Covas', number: '23', unit: '232', neighborhood: 'Santos Dumont',
                    city: 'Juiz de Fora', state: 'MG', country: 'Brasil', zip_code: '34050-098',
                    addressable_id: student.id, addressable_type: 'Student')
    # act
    login_as(admin)
    visit(root_path)
    click_on('Addresses')
    expect(page).to have_content('Aluno(a): Venossaur')
    expect(page).to have_content('Professor(a): Carvalho')
  end
end
