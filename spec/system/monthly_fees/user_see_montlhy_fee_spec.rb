require 'rails_helper'

RSpec.describe 'User vê taxas vencidas e a pagar' do
  it 'com sucesso' do
    admin =
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
    MonthlyFee.create!(
      student_id: student.id,
      due_date: '2024-04-04',
      value: 300,
      status: 'Paga'
    )

    login_as(admin)
    visit(root_path)
    click_on('Alunos')
    click_on('Detalhes')

    expect(page).to have_content('Mensalidades')
  end

  it 'e falha pois é teacher' do
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
    MonthlyFee.create!(
      student_id: student.id,
      due_date: '2024-04-04',
      value: 300,
      status: 'Paga'
    )

    login_as(user_teacher)
    visit(student_monthly_fees_path(student))

    expect(page).to have_content('Acesso negado.')
    expect(current_path).to eq teacher_home_path
  end
end
