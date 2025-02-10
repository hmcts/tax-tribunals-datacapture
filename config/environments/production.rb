require "active_support/core_ext/integer/time"

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

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = false
  config.sass.style = :compressed
  config.sass.line_comments = false

  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

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

  # Log to STDOUT with the current request id as a default log tag.
  config.logger = ActiveSupport::Logger.new(STDOUT)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process memory cache store with a durable alternative.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment).
  config.active_job.queue_adapter = :sidekiq
  config.action_mailer.deliver_later_queue_name = 'mailers'

  config.action_mailer.perform_deliveries = true
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  config.i18n.raise_on_missing_translations = false

  # Enable DNS rebinding protection and other `Host` header attacks.
  # config.hosts = [
  #   "example.com",     # Allow requests from example.com
  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
  # ]
  #
  # Skip DNS rebinding protection for the default health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
end
