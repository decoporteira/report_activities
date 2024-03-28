require 'rails_helper'

RSpec.describe 'Usuário cadastra um responsável financeiro' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student = Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')
    responsible = FinancialResponsible.create!(name: 'Oak', cpf: '000.000.000-01', email: 'oak@email.com', phone: '32 0000-0000')
    Responsible.create!(student_id: student.id, financial_responsible_id: responsible.id)

    login_as(user)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Detalhes')
    click_on('Editar Vínculo')
    click_on('Remover Responsável')

    expect(page).to have_content('Responsável removido com sucesso.')
  end
end
