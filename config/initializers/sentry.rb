# :nocov:
EXCLUDE_PATHS = ['/session/ping', '/session/ping.json', '/health', '/health.json'].freeze

Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', nil)
  config.breadcrumbs_logger = [:sentry_logger, :active_support_logger]
  config.environment = 'production'
  config.enabled_environments = ['production']

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 0.9

 # This line is from old sentry gem config. I checked and the data sent to sentry UI are filtered based on the
 # Rails.application.config.filter_parameters.map(&:to_s) values
 # config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  config.transport.ssl_verification = true

  config.traces_sampler = lambda do |sampling_context|
    transaction_context = sampling_context[:transaction_context]
    transaction_name = transaction_context[:name]

    transaction_name.in?(EXCLUDE_PATHS) ? 0.0 : 0.01
  end
end
# :nocov:
