# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'englishglobe.com.br', # Remove trailing ‘/’
  user_name: 'contatoenglishglobe@gmail.com', # Replace with your Gmail email
  password: 'wfnb ygii nhki qpfg', # Replace with the App Password you generated
  authentication: 'plain',
  enable_starttls_auto: true,
  open_timeout: 5,
  read_timeout: 5
}
