require 'rails_helper'

RSpec.describe 'User vê o numero de alunos' do
  it 'com sucesso' do
    # arrange
    Plan.create!(name: 'Kids', price: 350)
    Plan.create!(name: 'Teens', price: 350)
    Plan.create!(name: 'Adults', price: 350)
    Plan.create!(name: 'Privates', price: 350)

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
    student_one = Student.create!(
      name: 'Venossaur',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    student_two = Student.create!(
      name: 'Charmander',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '077.654.654-01'
    )
    student_three = Student.create!(
      name: 'Blastoise',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '065.654.654-01'
    )
    student_four = Student.create!(
      name: 'Caterpie',
      status: :registered,
      classroom_id: classroom.id,
      cpf: '063.654.654-01'
    )
    student_five = Student.create!(
      name: 'Pidgey',
      status: :unregistered,
      classroom_id: classroom.id,
      cpf: '072.654.654-01'
    )
    student_six = Student.create!(
      name: 'Ratata',
      status: :unregistered,
      cpf: '061.654.654-01'
    )
    Student.create!(
      name: 'Onix',
      status: :registered,
      cpf: '067.654.654-01'
    )
    User.create!(
      email: 'admin@admin.com.br',
      password: 'password',
      role: 'admin'
    )
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_one.id, plan_id: 1)
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_two.id, plan_id: 3)
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_three.id, plan_id: 4)
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_four.id, plan_id: 1)
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_five.id, plan_id: 3)
    CurrentPlan.create!(has_discount: false, discount: 0, student_id: student_six.id, plan_id: 4)

    admin = FactoryBot.create(:user, role: 'admin')
    # act
    login_as(admin)
    visit(root_path)

    # assert
    expect(page).to have_content('Venossaur')
    expect(page).to have_content('Charmander')
    expect(page).to have_content('Blastoise')
    expect(page).to_not have_content('Pidgey')
    expect(page).to have_content('Caterpie')
    expect(page).to_not have_content('Ratata')
    expect(page).to have_content('Kids: 2')
    expect(page).to have_content('Adults: 1')
    expect(page).to have_content('Privates: 1')
    expect(page).to have_content('Total de alunos: 5')
  end
end
