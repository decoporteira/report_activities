class PrivateLesson < ApplicationRecord
  belongs_to :current_plan
  delegate :teacher, to: :current_plan
end
