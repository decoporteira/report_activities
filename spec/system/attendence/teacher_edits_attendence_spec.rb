require 'rails_helper'

RSpec.describe 'Teacher edita presença' do
  it 'com sucesso' do
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
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    Student.create!(
      name: 'Blastoise',
      classroom_id: classroom.id,
      status: :registered
    )
    login_as(user_teacher)
    visit(root_path)
    click_on 'Enter Classroom'
    fill_in 'report', with: 'Megaevolução'
    fill_in 'date', with: '02/02/2025'
    click_on 'Criar atividade'

    expect(page).to have_content('Megaevolução (feito)')
    expect(page).to have_content('Blastoise | Presente')
    expect(page).to have_content('Marcar como Ausente')
    expect(Attendance.count).to eq 1
  end

  it 'E marca como ausente' do
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
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student =
      Student.create!(
        name: 'Blastoise',
        classroom_id: classroom.id,
        status: :registered
      )
    Activity.create!(
      report: 'Megaevolução',
      date: '02/02/2025',
      student_id: student.id,
      late: 'feito'
    )
    Attendance.create!(student_id: student.id, attendance_date: '02/02/2025')

    login_as(user_teacher)
    visit(classroom_path(classroom))
    click_on 'Marcar como Ausente'

    expect(page).to have_content('Presença marcada como Ausente.')
    expect(page).to have_content('Megaevolução (não fez)')
    expect(page).to have_content('Marcar como Presente')
    expect(page).to have_content('Blastoise | Ausente')
  end
  it 'E marca como presente' do
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
      Teacher.create(
        name: 'Bianca',
        status: 'disponível',
        user_id: user_teacher.id,
        cpf: '087.097.098-01'
      )
    classroom =
      Classroom.create!(name: 'MW 17:00', teacher_id: teacher.id, time: '23:00')
    student =
      Student.create!(
        name: 'Blastoise',
        classroom_id: classroom.id,
        status: :registered
      )
    Activity.create!(
      report: 'Megaevolução',
      date: '02/02/2025',
      student_id: student.id,
      late: 'feito'
    )
    Attendance.create!(
      student_id: student.id,
      attendance_date: '10/10/2024',
      presence: false
    )

    login_as(user_teacher)
    visit(classroom_path(classroom))
    click_on 'Marcar como Presente'

    expect(page).to have_content('Presença marcada como Presente.')
    expect(page).to have_content('Megaevolução (feito)')
    expect(page).to have_content('Marcar como Ausente')
    expect(page).to have_content('Blastoise | Presente')
  end
end
