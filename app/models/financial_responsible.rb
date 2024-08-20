class FinancialResponsible < ApplicationRecord
  has_many :responsibles
  has_many :students, through: :responsibles

  validates :name, presence: true
  validates :phone, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
