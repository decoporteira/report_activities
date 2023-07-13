class Student < ApplicationRecord
  # before_destroy :destroy_activities
  has_many :activities, dependent: :destroy
  belongs_to :classroom
  enum status: { 'Matriculado': 1, 'Não matriculado': 2 }
  validates_uniqueness_of :name, scope: :classroom

  private

  # def destroy_activities
  #   self.Activity.destroy_all
  # end
end
