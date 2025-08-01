class MonthlyFee < ApplicationRecord
  belongs_to :student
  validates :due_date, uniqueness: { scope: :student_id } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :due_date, :status, :value, presence: true
  enum status: { 'A pagar': 1, 'Atrasada': 2, 'Paga': 3 }


  def due_date_month_name
    due_date.present? ? I18n.l(due_date, format: '%B') : 'Data não definida'
  end

  def due_date_year
    due_date.present? ? due_date.year : 'Ano não definido'
  end

  def status_color
    {
      'Paga' => 'color: #0d6efd',
      'A pagar' => 'color: #6c757d',
      'Atrasada' => 'color: #dc3545'
    }[status]
  end

  def calculate_private_classes_payment_value
    class_value = student.current_plan.value_per_hour
    return 0 unless class_value

    due_date = self.due_date
    start_date = (due_date - 1.month).beginning_of_month
    end_date = start_date.end_of_month.end_of_day
    classes_count = student.current_plan.private_lessons.where(start_time: start_date..end_date).count
    class_value * classes_count
  end

  def calculate_payment_value
    plan = student.current_plan.plan
    return self.value if plan.monthly? || self.status == 'Paga'

    total = calculate_private_classes_payment_value
    plan.both? ? total + self.value : total
  end
end
