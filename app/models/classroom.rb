class Classroom < ApplicationRecord
  belongs_to :teacher
  has_many :students, dependent: :destroy
  validates :name, :time, :teacher_id, presence: true
  include DateRangeHelper

  def name_with_teacher_name
    "#{name} - #{teacher.name}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name teacher_id time updated_at]
  end

  def set_students_data(start_date, end_date)
    students.each_with_object({}) do |student, result|
      result[student.id] = {
        activities: student.activities.where(date: start_date..end_date).order(date: :desc),
        attendances: student.attendances.where(attendance_date: start_date..end_date).order(:attendance_date)
      }
    end
  end

  def generate_data(last_semester)
    start_date, end_date = get_date_range(last_semester)
    {
      students: students.where(status: :registered),
      students_data: set_students_data(start_date, end_date),
    }
  end
end
