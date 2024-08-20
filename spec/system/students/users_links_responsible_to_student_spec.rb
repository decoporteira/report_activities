require 'rails_helper'

RSpec.describe 'Usuário linka responsável financeiro' do
  it 'com sucesso' do
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    FinancialResponsible.create!(
      name: 'Carvalho',
      cpf: '000.000.000-01',
      email: 'carvalho@gmail.com',
      phone: '32 0000-0000'
    )
    FinancialResponsible.create!(
      name: 'Joy',
      cpf: '000.000.000-02',
      email: 'joy@gmail.com',
      phone: '33 0000-0000'
    )

    login_as(user)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Vincular Responsável Existente')
    select 'Joy', from: 'financial_responsible_id'
    click_on('Salvar')

    expect(page).to have_content('Responsável vinculado com sucesso.')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Nome: Joy | Telefone: 33 0000-0000')
    expect(page).to have_content('Responsável Financeiro')
  end

  it 'e falha' do
    user =
      User.create!(
        email: 'admin@admin.com.br',
        password: 'password',
        role: 'admin'
      )
    user_teacher =
      User.create!(
        email: 'teacher@admin.com.br',
        password: 'password',
        role: 'teacher'
      )
    teacher =
      Teacher.create!(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student =
      Student.create!(
        name: 'Venossaur',
        status: :registered,
        classroom_id: classroom.id,
        cpf: '065.654.654-01'
      )
    FinancialResponsible.create!(
      name: 'Carvalho',
      cpf: '000.000.000-01',
      email: 'carvalho@gmail.com',
      phone: '32 0000-0000'
    )
    fr =
      FinancialResponsible.create!(
        name: 'Joy',
        cpf: '000.000.000-02',
        email: 'joy@gmail.com',
        phone: '33 0000-0000'
      )
    Responsible.create!(student_id: student.id, financial_responsible_id: fr.id)

    login_as(user)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')
    click_on('Vincular Responsável Existente')
    select 'Joy', from: 'financial_responsible_id'
    click_on('Salvar')

    expect(page).to have_content('Não foi possível vincular o Responsável.')
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Responsável Financeiro')
  end
end
