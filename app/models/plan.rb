class Plan < ApplicationRecord
  enum plan_type: { kids: 0, teens: 1, adults: 2, test: 33}
end
