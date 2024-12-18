Rails.application.configure do
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
  config.lograge.logger = ActiveSupport::Logger.new(STDOUT)
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.log_level = :info
  config.action_view.logger = nil

  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format id)
    {
      host: event.payload[:host],
      params: event.payload[:params].except(*exceptions),
      referrer: event.payload[:referrer],
      session_id: event.payload[:session_id],
      tags: %w{taxtribs-datacapture},
      user_agent: event.payload[:user_agent]
    }
  end

  config.cache_classes = true
  config.cache_store = :memory_store
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.year.to_i}, immutable"
  }

  config.eager_load = true

  config.consider_all_requests_local       = false

  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = false
  config.sass.style = :compressed
  config.sass.line_comments = false

  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true
  config.ssl_options = {
    hsts: { expires: 1.year, preload: true },
    redirect: { exclude: ->(request) { /status\.json|\/health\/liveness|\/health\/readiness/.match?(request.path) } }
  }

  # Security policies
  config.action_dispatch.default_headers = {
    "X-Frame-Options" => "DENY",
    "X-XSS-Protection" => "0",
    'Cross-Origin-Embedder-Policy' => 'require-corp',
    'Cross-Origin-Resource-Policy' => 'same-site',
    'Cross-Origin-Opener-Policy' => 'same-origin',
    'Permissions-Policy' => 'geolocation=(), camera=(), microphone=(), interest-cohort=()',
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains; preload',
    'X-DNS-Prefetch-Control' => 'off',
  }

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # "info" includes generic and useful information about system operation, but avoids logging too much
  # information to avoid inadvertent exposure of personally identifiable information (PII). If you
  # want to log everything, set the level to "debug".
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter = :sidekiq

  config.action_mailer.delivery_method = :govuk_notify
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.deliver_later_queue_name = 'mailers'

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.active_record.dump_schema_after_migration = false

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.i18n.raise_on_missing_translations = false

  config.active_record.dump_schema_after_migration = false
end
