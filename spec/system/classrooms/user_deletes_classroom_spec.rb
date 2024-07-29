require 'rails_helper'

RSpec.describe 'Admin edita classroom' do
  it 'com sucesso' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher.id, cpf: '087.097.098-01')
    Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')

    login_as(user)
    visit(root_path)
    click_on 'Turmas'
    click_on 'Show this classroom'
    click_on 'Destroy this classroom'

    expect(Classroom.count).to eq(0)
    expect(page).to have_content('Turma apagada com sucesso')

  end

  it 'fails because has 1 student' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Ash Ketchum', status: 'Matriculado', classroom: classroom )

    login_as(user)
    visit(root_path)
    click_on 'Turmas'
    click_on 'Show this classroom'
    click_on 'Destroy this classroom'

    expect(Classroom.count).to eq(1)
    expect(page).to have_content('Não foi possível apagar a turma.')

  end
  it 'fails because has 2 students' do
    user = User.create!(email: 'admin@admin.com.br', password: 'password', role: 'admin')
    teacher = User.create!(email: 'teacher@admin.com.br', password: 'password', role: 'teacher')
    teacher = Teacher.create(name: 'Bianca', status: 'disponível', user_id: teacher.id, cpf: '087.097.098-01')
    classroom = Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(name: 'Ash Ketchum', status: 'Matriculado', classroom:)
    Student.create!(name: 'Misty', status: 'Matriculado', classroom:)

    login_as(user)
    visit(root_path)
    click_on 'Turmas'
    click_on 'Show this classroom'
    click_on 'Destroy this classroom'

    expect(Classroom.count).to eq(1)
    expect(page).to have_content('Não foi possível apagar a turma.')
  end
end
