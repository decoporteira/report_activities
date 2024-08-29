json.extract! current_plan, :id, :plan_id, :has_discount, :discount, :student_id, :created_at, :updated_at
json.url current_plan_url(current_plan, format: :json)
