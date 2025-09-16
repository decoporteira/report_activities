require 'rails_helper'

RSpec.describe BillingResponsiblesJob, type: :worker do
  it 'marks all past monthly fees as atrasadas' do
    # Setup de usuários, professores, turmas e alunos
    admin = FactoryBot.create(:user, role: 'admin')
    user_teacher = FactoryBot.create(:user, role: 'teacher')
    teacher = FactoryBot.create(:teacher, user: user_teacher)
    classroom = FactoryBot.create(:classroom, teacher: teacher)

    student_a = FactoryBot.create(:student, classroom: classroom)
    student_b = FactoryBot.create(:student, classroom: classroom)

    plan_a = FactoryBot.create(:plan, name: 'Kids', price: 300)
    FactoryBot.create(:current_plan, plan: plan_a, student: student_a)
    FactoryBot.create(:current_plan, plan: plan_a, student: student_b)

    # Cria mensalidades (A pagar) para teste
    CreateAnualFees.new.perform

    # Identifica mensalidades passadas e futuras
    past_fees = MonthlyFee.where('due_date < ?', Time.zone.today)
    future_fees = MonthlyFee.where('due_date >= ?', Time.zone.today)

    # Chama o worker
    BillingResponsiblesJob.new.perform

    # Verifica que todas as mensalidades passadas agora estão atrasadas
    past_fees.each do |fee|
      expect(fee.reload.status).to eq('Atrasada')
    end

    # Verifica que as futuras não foram alteradas
    future_fees.each do |fee|
      expect(fee.reload.status).to eq('A pagar')
    end
  end
end
