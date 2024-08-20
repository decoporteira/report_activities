json.extract! student,
              :id,
              :name,
              :status,
              :classroom_id,
              :created_at,
              :updated_at
json.url student_url(student, format: :json)
