class PrivateLesson < ApplicationRecord
  belongs_to :current_plan
  delegate :teacher, to: :current_plan

  validates :current_plan_id, :start_time, presence: true
  after_save :calculate_private_classes

  def calculate_private_classes
    total = MonthlyFee.calculate_private_classes_payment(self)

    base_date = start_time || Date.today
    due_date = base_date.to_date.next_month.change(day: 10)

    student = current_plan.student
    mf = student.monthly_fees.find_or_initialize_by(due_date: due_date)
    mf.student = student
    mf.value = total
    mf.status = 'A pagar'
    mf.has_discount = false if mf.has_discount

    mf.save!
  end
end
