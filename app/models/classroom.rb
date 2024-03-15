class Classroom < ApplicationRecord
  belongs_to :teacher
  has_many :students, dependent: :destroy
  validates :name, :time, :teacher_id, presence: true

  def name_with_teacher_name
    "#{name} - #{teacher.name}"
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name teacher_id time updated_at]
  end
end
