require 'rails_helper'

RSpec.describe 'Admin cria taxas mensais' do
  it 'com sucesso' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Cadastrar Mensalidade')

    fill_in 'Vencimento', with: '2005/04/04'
    fill_in 'Valor', with: '300,00'
    select 'Pagamento Em Atraso', from: 'Status'

    expect { click_on 'Criar Mensalidade' }.to change { MonthlyFee.count }.by(1)
    expect(page).to have_content('Mensalidade criada com sucesso.')
  end
  it 'com sucesso' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Cadastrar Mensalidade')

    fill_in 'Vencimento', with: '2024/04/04'
    fill_in 'Valor', with: '300,00'
    select 'Pago', from: 'Status'

    expect { click_on 'Criar Mensalidade' }.to change { MonthlyFee.count }.by(1)
    expect(page).to have_content('Mensalidade criada com sucesso.')
  end

  it 'E falha por não ser admin' do
    user_teacher = User.create!(email: 'teacher@teacher.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: 'Matriculado', classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(user_teacher)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    expect(page).not_to have_content('Cadastrar Mensalidade')
  end
end
