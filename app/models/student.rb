class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :monthly_fees
  has_many :responsibles
  has_one :current_plan
  belongs_to :plan, optional: true
  has_many :financial_responsibles, through: :responsibles
  has_many :activities, dependent: :destroy
  belongs_to :classroom, optional: true
  has_many :resumes, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  enum status: { registered: 1, unregistered: 2 }
  validates :name, uniqueness: { scope: :classroom }
  validates :name, :status, presence: true

  include DateRangeHelper

  def self.ransackable_attributes(_auth_object = nil)
    %w[classroom_id created_at id name status updated_at activities classroom]
  end

  def find_activities(start_date, end_date)
    activities.where(date: start_date..end_date).order(:date)
  end

  def set_resume(start_date, end_date)
    resumes.where(created_at: start_date..end_date).first
  end

  def number_of_absences(start_date, end_date)
    attendances
      .where(presence: false)
      .where(
        'attendance_date >= ? AND attendance_date <= ?',
        start_date,
        end_date
      )
      .count
  end

  def generate_report(last_semester)
    start_date, end_date = get_date_range(last_semester)
    {
      activities: find_activities(start_date, end_date),
      resume: set_resume(start_date, end_date),
      number_of_absence: number_of_absences(start_date, end_date)
    }
  end

  def update_current_plan(plan_id, has_discount: false, discount: nil)
    current_plan = self.current_plan || build_current_plan
    current_plan.update(
      plan_id:,
      has_discount:,
      discount:
    )
  end
end
