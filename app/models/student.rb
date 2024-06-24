class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :monthly_fees
  has_many :responsibles
  has_many :financial_responsibles, through: :responsibles
  has_many :activities, dependent: :destroy
  belongs_to :classroom
  has_many :resumes, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  enum status: { 'Matriculado': 1, 'Não matriculado': 2 }
  validates :name, uniqueness: { scope: :classroom }
  validates :name, :status, :classroom_id, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[classroom_id created_at id name status updated_at activities classroom]
  end
end
