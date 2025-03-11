require 'rails_helper'

RSpec.describe 'User vê o numero de alunos' do
  it 'com sucesso' do
    kids_plan = FactoryBot.create(:plan, name: 'Kids', price: 350)
    adults_plan = FactoryBot.create(:plan, name: 'Adults', price: 350)
    privates_plan = FactoryBot.create(:plan, name: 'Particular', price: 350)

    user_teacher = FactoryBot.create(:user, email: 'teacher@admin.com.br', role: 'teacher')
    teacher = FactoryBot.create(:teacher, name: 'Bianca', user: user_teacher, cpf: '087.097.098-01')
    classroom = FactoryBot.create(:classroom, name: 'MW 17:00', teacher:)

    student_one = FactoryBot.create(:student, name: 'Venossaur', status: :registered, classroom:)
    student_two = FactoryBot.create(:student, name: 'Charmander', status: :registered, classroom:)
    student_three = FactoryBot.create(:student, name: 'Blastoise', status: :registered, classroom:)
    student_four = FactoryBot.create(:student, name: 'Caterpie', status: :registered, classroom:)
    student_five = FactoryBot.create(:student, name: 'Pidgey', status: :unregistered, classroom:)
    student_six = FactoryBot.create(:student, name: 'Ratata', status: :unregistered)

    FactoryBot.create(:current_plan, student: student_one, plan: kids_plan)
    FactoryBot.create(:current_plan, student: student_two, plan: adults_plan)
    FactoryBot.create(:current_plan, student: student_three, plan: privates_plan)
    FactoryBot.create(:current_plan, student: student_four, plan: kids_plan)
    FactoryBot.create(:current_plan, student: student_five, plan: adults_plan)
    FactoryBot.create(:current_plan, student: student_six, plan: privates_plan)

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
    expect(page).to have_content('Total de alunos: 4')
  end
end
