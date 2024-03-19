
class FinancialResponsible < ApplicationRecord
  validates :name, presence: true
  validates :phone, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end