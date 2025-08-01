class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :monthly_fees
  has_many :responsibles
  has_one :current_plan
  has_one :plan, through: :current_plan
  has_many :financial_responsibles, through: :responsibles
  has_many :activities, dependent: :destroy
  has_many :material_billings
  belongs_to :classroom, optional: true
  has_many :resumes, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  enum status: { registered: 1, unregistered: 2 }
  validates :name, uniqueness: { scope: :classroom }
  validates :name, :status, presence: true
  scope :active, -> { where(status: :registered) }
  scope :inactive, -> { where(status: :unregistered) }
  scope :with_fees, -> { where(status: :registered).includes(:monthly_fees) }
  scope :with_monthly_fees_for_year, lambda { |year|
    includes(:monthly_fees, :financial_responsibles, :classroom)
      .where(monthly_fees: { due_date: Date.new(year.to_i).beginning_of_year..Date.new(year.to_i).end_of_year })
  }
  scope :with_monthly_fees_for_semester, lambda { |year|
  joins(:monthly_fees)
    .where(monthly_fees: { due_date: Date.new(year.to_i, 8, 1)..Date.new(year.to_i).end_of_year })
    .distinct
}
   scope :with_plan_per_class, -> {
    joins(current_plan: :plan).where(plans: { billing_type: :per_class }).active
  }


  include DateRangeHelper

  def first_and_last_name
    parts = name.to_s.strip.split
    return name if parts.size <= 1
    "#{parts.first} #{parts.last}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[classroom_id created_at id name status updated_at activities classroom]
  end

  def get_private_classes(date)
    start_of_month = date.beginning_of_month
    end_of_month = date.end_of_month.end_of_day
    current_plan.private_lessons.where(start_time: start_of_month..end_of_month).count * (current_plan.value_per_hour || 0)
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

  def monthly_fees_by_month
    @monthly_fees_by_month ||= monthly_fees.index_by(&:due_date_month_name)
  end

  def has_per_class_plan?
    current_plan&.plan&.per_class?
  end
end
