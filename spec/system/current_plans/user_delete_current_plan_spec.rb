require 'rails_helper'

RSpec.describe 'Usuário apaga mensalidade' do
  it 'com sucesso' do
    admin = FactoryBot.create(:user, role: 'admin')
    plan_one = FactoryBot.create(:plan, name: 'Kids', price: 330)
    plan_two = FactoryBot.create(:plan, name: 'Adults', price: 350)
    classroom = FactoryBot.create(:classroom)
    student_one = FactoryBot.create(:student, classroom:)
    student_two = FactoryBot.create(:student, classroom:)
    student_three = FactoryBot.create(:student, classroom: nil)
    FactoryBot.create(:current_plan, plan_id: plan_one.id, student_id: student_one.id)
    FactoryBot.create(:current_plan, plan_id: plan_one.id, student_id: student_two.id)
    FactoryBot.create(:current_plan, plan_id: plan_two.id, student_id: student_three.id)

    login_as(admin)
    visit(root_path)
    click_on('Finanças')
    click_on('Curso por aluno')
    click_on("Show #{student_one.name}'s current plan")
    click_on('Destroy this current plan')

    expect(student_one.current_plan).to eq(nil)
    expect(student_two.current_plan.plan.name).to eq('Kids')
    expect(student_three.current_plan.plan.name).to eq('Adults')
  end
end
