class MonthlyFee < ApplicationRecord
  belongs_to :student
  validates :due_date, :status, :value, presence: true
  enum status: { 'A pagar': 1, 'Pagamento em atraso': 2, 'Pago': 3 }

  def due_date_month_name
    due_date.present? ? I18n.l(due_date, format: '%B') : 'Data não definida'
  end

  # Retorna o ano da due_date
  def due_date_year
    due_date.present? ? due_date.year : 'Ano não definido'
  end

end
