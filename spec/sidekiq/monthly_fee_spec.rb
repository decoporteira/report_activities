require 'rails_helper'

RSpec.describe CreateMonthlyFees, type: :worker do
  it 'creates monthly fees for students' do
    FactoryBot.create(:user, role: 'admin')
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, teacher_id: teacher.id)

    student = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    student_b = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)
    student_c = FactoryBot.create(:student, name: 'Squirtle', classroom_id: classroom.id)

    FactoryBot.create(:student, name: 'Caterpie', classroom_id: classroom.id)
    FactoryBot.create(:student, name: 'Stariu', status: 'unregistered', classroom_id: classroom.id)

    plan = FactoryBot.create(:plan, name: 'Kids', price: 300)
    plan_b = FactoryBot.create(:plan, name: 'Adult', price: 350)

    FactoryBot.create(:current_plan, plan:, student:)
    FactoryBot.create(:current_plan, plan:, student: student_b)
    FactoryBot.create(:current_plan, plan: plan_b, student: student_c)

    CreateMonthlyFees.new.perform

    expect(MonthlyFee.count).to eq(3)
  end
end
