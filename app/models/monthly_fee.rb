class MonthlyFee < ApplicationRecord
  belongs_to :student
  validates :due_date, uniqueness: { scope: :student_id } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :due_date, :status, :value, presence: true
  enum status: { 'A pagar': 1, 'Atrasada': 2, 'Paga': 3 }
  validate :positive_price

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

  def positive_price
    return unless value.present? && student.current_plan&.plan&.price.present?
    return unless value > student.current_plan.plan.price

    errors.add(:value,
               "A mensalidade não pode ser maior que o valor do plano. Valor do plano: R$ #{student.current_plan.plan.price}")
  end
end
