json.extract! billing, :id, :name, :email, :created_at, :updated_at
json.url billing_url(billing, format: :json)
