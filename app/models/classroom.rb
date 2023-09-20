class Classroom < ApplicationRecord
  belongs_to :teacher
  has_many :students, dependent: :destroy
  validates_presence_of :name, :time, :teacher_id

  def name_with_teacher_name
    "#{name} - #{teacher.name}"
  end
end
