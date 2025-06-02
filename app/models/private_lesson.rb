class PrivateLesson < ApplicationRecord
  belongs_to :current_plan
  delegate :teacher, to: :current_plan

  validates :current_plan_id, :start_time, presence: true
  
end
