class Classroom < ApplicationRecord
  belongs_to :teacher
  has_many :students, dependent: :destroy
  validates_presence_of :name, :time, :teacher_id
end
