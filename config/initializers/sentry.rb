Sentry.init do |config|
  config.dsn =
    'https://9707d2e84746661d5b858bd1eded34cb@o4505907651936256.ingest.sentry.io/4505907652853760'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0

  # or
  config.traces_sampler = lambda { |context| true }
end
