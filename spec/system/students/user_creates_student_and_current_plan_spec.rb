require 'rails_helper'

RSpec.describe 'Tipo de usuário cria uma student' do
  it 'Admin a partir do menu' do
    # arrange
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    FactoryBot.create(:plan, name: 'Adults', price: 330)
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, name: 'Bianca', user_id: user_teacher.id)
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    user = FactoryBot.create(:user, role: 'admin')

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'
    click_on 'New student'
    fill_in 'Nome', with: 'Onix'
    fill_in 'cpf', with: '000.000.000-01'
    select 'Matriculado', from: 'student_status'
    select 'MW 17:00', from: 'student_classroom_id'
    select 'Kids', from: 'student_plan_id'
    click_on 'Criar Aluno'

    # assert
    expect(page).to have_content('Aluno(a) criado(a) com sucesso.')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 000.000.000-01')
    expect(page).to have_content('Curso: Kids')
  end

  it 'Admin a partir do menu e criar a mensalidade do mes atual' do
    # arrange
    FactoryBot.create(:plan, name: 'Adults', price: 330)
    FactoryBot.create(:plan, name: 'Kids', price: 330)
    
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, name: 'Bianca', user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, name: 'MW 17:00', teacher_id: teacher.id, time: '23:00' )
    user = FactoryBot.create(:user, role: 'admin')
    venossaur = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    charmander = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'
    click_on 'New student'
    fill_in 'Nome', with: 'Onix'
    fill_in 'cpf', with: '000.000.000-01'
    select 'Matriculado', from: 'student_status'
    select 'MW 17:00', from: 'student_classroom_id'
    select 'Kids', from: 'student_plan_id'

    expect {
      click_on 'Criar Aluno'
    }.to change(MonthlyFee, :count).by(1)

    mf = MonthlyFee.last
    today = Time.zone.today

    # Garantir mensagem e dados na tela
    expect(page).to have_content('Aluno(a) criado(a) com sucesso.')
    expect(page).to have_content('Onix')
    expect(page).to have_content('Professor(a): Bianca')
    expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 000.000.000-01')
    expect(page).to have_content('Curso: Kids')

    # Garantir que mensalidade é do aluno certo
    expect(mf.student.name).to eq('Onix')

    # Garantir que alunos antigos não receberam mensalidade
    expect(venossaur.monthly_fees).to be_empty
    expect(charmander.monthly_fees).to be_empty

    # Garantir que mensalidade é do mês/ano atual
    expect(mf.due_date.month).to eq(today.month)
    expect(mf.due_date.year).to eq(today.year)
  end
  it 'Admin a partir do menu e criar a mensalidade do mes atual' do
    # arrange
    FactoryBot.create(:plan, name: 'Particular', price: 150, billing_type: 'per_class')

    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, name: 'Bianca', user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, name: 'MW 17:00', teacher_id: teacher.id, time: '23:00' )
    user = FactoryBot.create(:user, role: 'admin')
    venossaur = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    charmander = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)

    # act
    login_as(user)
    visit(root_path)
    click_on 'Alunos'
    click_on 'New student'
    fill_in 'Nome', with: 'Onix'
    fill_in 'cpf', with: '000.000.000-01'
    select 'Matriculado', from: 'student_status'
    select 'Particular', from: 'student_plan_id'
    #select 'Bianca', from: 'student_teacher_id'

    expect {
      click_on 'Criar Aluno'
    }.to change(MonthlyFee, :count).by(1)

    mf = MonthlyFee.last
    today = Time.zone.today

    # Garantir mensagem e dados na tela
    expect(page).to have_content('Aluno(a) criado(a) com sucesso.')
    expect(page).to have_content('Onix')
    #expect(page).to have_content('Professor(a): Bianca')
    #expect(page).to have_content('Turma: MW 17:00')
    expect(page).to have_content('CPF: 000.000.000-01')
    expect(page).to have_content('Cursos: Particular')

    # Garantir que mensalidade é do aluno certo
    expect(mf.student.name).to eq('Onix')

    # Garantir que alunos antigos não receberam mensalidade
    expect(venossaur.monthly_fees).to be_empty
    expect(charmander.monthly_fees).to be_empty

    # Garantir que mensalidade é do mês/ano atual
    expect(mf.due_date.month).to eq(today.month)
    expect(mf.due_date.year).to eq(today.year)
  end
end
