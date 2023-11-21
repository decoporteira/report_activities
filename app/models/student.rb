class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :activities, dependent: :destroy
  belongs_to :classroom
  has_one  :resume
  enum status: { 'Matriculado': 1, 'Não matriculado': 2 }
  validates_uniqueness_of :name, scope: :classroom
  validates_presence_of :name, :status, :classroom_id

  def self.ransackable_attributes(auth_object = nil)
    ["classroom_id", "created_at", "id", "name", "status", "updated_at", "activities", "classroom"]
  end
end
