class Responsible < ApplicationRecord
  belongs_to :financial_responsible
  belongs_to :student

  validates :financial_responsible_id, uniqueness: { scope: :student_id }
end
