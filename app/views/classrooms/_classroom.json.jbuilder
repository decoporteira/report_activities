json.extract! classroom,
              :id,
              :name,
              :time,
              :teacher_id,
              :created_at,
              :updated_at
json.url classroom_url(classroom, format: :json)
