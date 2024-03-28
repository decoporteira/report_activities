class Responsible < ApplicationRecord
  belongs_to :student
  belongs_to :financial_responsible
end
