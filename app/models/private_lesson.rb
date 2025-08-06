class PrivateLesson < ApplicationRecord
  belongs_to :current_plan
  delegate :teacher, to: :current_plan

  validates :current_plan_id, :start_time, presence: true
  after_save :calculate_private_classes

  def calculate_private_classes
    total = MonthlyFee.calculate_private_classes_payment(self)
    mf = current_plan.student.monthly_fees.find_by(due_date: start_time.to_date.beginning_of_month.next_month.change(day: 10))
    mf.update(value: total)
    #puts "------------------------------------ Total: #{total}-----------------------------------------------------------"
    #puts "------------------------------------ Vencimento: #{mf.due_date}-----------------------------------------------------------"
    #puts "------------------------------------ Name: #{mf.student.name}-----------------------------------------------------------"
    #puts "------------------------------------ Id: #{mf.id}-----------------------------------------------------------"
    #puts "------------------------------------ Value: #{mf.value}-----------------------------------------------------------"
  end
end
