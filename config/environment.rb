# Load the Rails application.
require_relative "application"
# Load the app's custom environment variables here, so that they are loaded before environments/*.rb
app_environment_variables = File.join(Rails.root, 'config', 'app_environment_variables.rb')
load(app_environment_variables) if File.exist?(app_environment_variables)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
    address: 'smtp.gmail.com',
    port: 587,
    domain: 'englishglobe.com.br', # Remove trailing ‘/’
    user_name: 'decodesiste@gmail.com', # Replace with your Gmail email
    password: ENV['SMTP_PASS'], # Replace with the App Password you generated
    authentication: 'plain',
    enable_starttls_auto: true,
    open_timeout: 5,
    read_timeout: 5
}