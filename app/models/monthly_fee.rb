class MonthlyFee < ApplicationRecord
  belongs_to :student
  validates :due_date, uniqueness: { scope: :student_id }
  validates :due_date, :status, :value, presence: true
  enum status: { 'A pagar': 1, 'Atrasada': 2, 'Paga': 3 }

  def due_date_month_name
    due_date.present? ? I18n.l(due_date, format: '%B') : 'Data não definida'
  end

  def due_date_year
    due_date.present? ? due_date.year : 'Ano não definido'
  end
end
