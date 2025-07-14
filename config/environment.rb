# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options = {
  host: 'reports.englishglobe.com.br',
  protocol: 'https'
}
ActionMailer::Base.smtp_settings = {
  address: 'mail.smtp2go.com',
  port: 2525,
  domain: 'englishglobe.com.br', 
    user_name: Rails.application.credentials.dig(:new_smtp, :user_name), 
    password: Rails.application.credentials.dig(:new_smtp, :password),
  authentication: 'plain',
  enable_starttls_auto: true,
  open_timeout: 10,
  read_timeout: 10,
  family: :inet,
}