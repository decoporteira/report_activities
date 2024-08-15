require 'rails_helper'

RSpec.describe 'Cria todas as mensalidades do ano' do
  it 'com sucesso' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Financeiro')
    click_on('Criar Mensalidades')

    expect(page).to have_content('Mensalidades criadas com sucesso.')
  end

  it 'com sucesso em janeiro' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Financeiro')
    travel_to Time.zone.local(2024, 1, 1) do
      click_on 'Criar Mensalidades'
    end

    expect(page).to have_content('Mensalidades criadas com sucesso.')
    expect(page).not_to have_content('10/01/2024')
    expect(page).to have_content('10/02/2024')
    expect(page).to have_content('10/03/2024')
    expect(page).to have_content('10/04/2024')
    expect(page).to have_content('10/05/2024')
    expect(page).to have_content('10/06/2024')
    expect(page).to have_content('10/07/2024')
    expect(page).to have_content('10/08/2024')
    expect(page).to have_content('10/09/2024')
    expect(page).to have_content('10/10/2024')
    expect(page).to have_content('10/11/2024')
    expect(page).to have_content('10/12/2024')
  end

  it 'com sucesso em março, antes do dia 10' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Financeiro')
    travel_to Time.zone.local(2024, 3, 3) do
      click_on 'Criar Mensalidades'
    end

    expect(page).to have_content('Mensalidades criadas com sucesso.')
    expect(page).not_to have_content('10/01/2024')
    expect(page).not_to have_content('10/02/2024')
    expect(page).to have_content('10/03/2024')
    expect(page).to have_content('10/04/2024')
    expect(page).to have_content('10/05/2024')
    expect(page).to have_content('10/06/2024')
    expect(page).to have_content('10/07/2024')
    expect(page).to have_content('10/08/2024')
    expect(page).to have_content('10/09/2024')
    expect(page).to have_content('10/10/2024')
    expect(page).to have_content('10/11/2024')
    expect(page).to have_content('10/12/2024')
  end

  it 'com sucesso em março, depois dia 10' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Financeiro')
    travel_to Time.zone.local(2024, 3, 20) do
      click_on 'Criar Mensalidades'
    end

    expect(page).to have_content('Mensalidades criadas com sucesso.')
    expect(page).not_to have_content('10/01/2024')
    expect(page).not_to have_content('10/02/2024')
    expect(page).to have_content('10/03/2024')
    expect(page).to have_content('10/04/2024')
    expect(page).to have_content('10/05/2024')
    expect(page).to have_content('10/06/2024')
    expect(page).to have_content('10/07/2024')
    expect(page).to have_content('10/08/2024')
    expect(page).to have_content('10/09/2024')
    expect(page).to have_content('10/10/2024')
    expect(page).to have_content('10/11/2024')
    expect(page).to have_content('10/12/2024')
  end

  it 'com sucesso em dezembro, depois dia 10' do
    admin = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    user_teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create!(name: 'Bianca', status: 'disponível', user_id: user_teacher.id,
                              cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Venossaur', status: :registered, classroom_id: classroom.id,
                    cpf: '065.654.654-01')

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Financeiro')
    travel_to Time.zone.local(2024, 12, 20) do
      click_on 'Criar Mensalidades'
    end

    expect(page).to have_content('Mensalidades criadas com sucesso.')
    expect(page).not_to have_content('10/01/2024')
    expect(page).not_to have_content('10/02/2024')
    expect(page).not_to have_content('10/03/2024')
    expect(page).not_to have_content('10/04/2024')
    expect(page).not_to have_content('10/05/2024')
    expect(page).not_to have_content('10/06/2024')
    expect(page).not_to have_content('10/07/2024')
    expect(page).not_to have_content('10/08/2024')
    expect(page).not_to have_content('10/09/2024')
    expect(page).not_to have_content('10/10/2024')
    expect(page).not_to have_content('10/11/2024')
    expect(page).to have_content('10/12/2024')
  end
end
