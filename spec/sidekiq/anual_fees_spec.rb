require 'rails_helper'

RSpec.describe CreateAnualFees, type: :worker do
  it 'creates monthly fees for students' do
    FactoryBot.create(:user, role: 'admin')
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, teacher_id: teacher.id)

    student_a = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    student_b = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)
    student_c = FactoryBot.create(:student, name: 'Squirtle', classroom_id: classroom.id)
    student_d = FactoryBot.create(:student, name: 'Caterpie', classroom_id: classroom.id)
    student_e = FactoryBot.create(:student, name: 'Stariu', status: 'unregistered', classroom_id: classroom.id)

    plan_a = FactoryBot.create(:plan, name: 'Kids', price: 300)
    plan_b = FactoryBot.create(:plan, name: 'Adult', price: 350)

    FactoryBot.create(:current_plan, plan: plan_a, student: student_a)
    FactoryBot.create(:current_plan, plan: plan_a, student: student_b)
    FactoryBot.create(:current_plan, plan: plan_b, student: student_c)

    CreateAnualFees.new.perform

    expect(MonthlyFee.count).to eq(33)
  end
  it 'creates monthly fees for students when there is a MF already created' do
    FactoryBot.create(:user, role: 'admin')
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user_id: user_teacher.id)
    classroom = FactoryBot.create(:classroom, teacher_id: teacher.id)

    student_a = FactoryBot.create(:student, name: 'Venossaur', classroom_id: classroom.id)
    student_b = FactoryBot.create(:student, name: 'Charmander', classroom_id: classroom.id)
    student_c = FactoryBot.create(:student, name: 'Squirtle', classroom_id: classroom.id)
    student_d = FactoryBot.create(:student, name: 'Caterpie', classroom_id: classroom.id)
    student_e = FactoryBot.create(:student, name: 'Stariu', status: 'unregistered', classroom_id: classroom.id)

    plan_a = FactoryBot.create(:plan, name: 'Kids', price: 300)
    plan_b = FactoryBot.create(:plan, name: 'Adult', price: 350)

    FactoryBot.create(:current_plan, plan: plan_a, student: student_a)
    FactoryBot.create(:current_plan, plan: plan_a, student: student_b)
    FactoryBot.create(:current_plan, plan: plan_b, student: student_c)

    FactoryBot.create(:monthly_fee, student: student_a, due_date: Date.new(2025, 7, 10), status: 'A pagar')

    travel_to Time.zone.local(2025, 5, 5) do
      CreateAnualFees.new.perform
    end

    expect(MonthlyFee.count).to eq(33)
  end
end
