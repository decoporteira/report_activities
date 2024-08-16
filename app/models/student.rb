class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :monthly_fees
  has_many :responsibles
  has_many :financial_responsibles, through: :responsibles
  has_many :activities, dependent: :destroy
  belongs_to :classroom, optional: true
  has_many :resumes, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  enum status: { registered: 1, not_registered: 2 }
  validates :name, uniqueness: { scope: :classroom }
  validates :name, :status, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[classroom_id created_at id name status updated_at activities classroom]
  end

  def find_activities(start_date, end_date)
    activities.where(date: start_date..end_date).order(:date)
  end

  def set_resume(start_date, end_date)
    resumes.where(created_at: start_date..end_date).first
  end

  def set_done_activities
    activities.where(late: 'feito')
  end
  
  def set_late_activities
    activities.where(late: 'entregue com atraso')
  end

  def set_not_done_activities
    activities.where(late: 'não fez')
  end
end
