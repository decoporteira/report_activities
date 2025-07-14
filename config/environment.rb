# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'englishglobe.com.br', 
    user_name: Rails.application.credentials.dig(:smtp, :user_name), 
    password: Rails.application.credentials.dig(:smtp, :password),
  authentication: 'plain',
  enable_starttls_auto: true,
  open_timeout: 10,
  read_timeout: 10,
  family: :inet,
}