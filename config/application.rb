require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaxTribunalsDatacapture
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets generators tasks])

    # *** Add environment variables ***
    #
    # In CFT, env vars are mounted to the filesystem.
    #
    # Must be done here and not an initializer as
    # env vars are needed for boot.
    #
    # Note we don't overwrite env vars that are already set
    # because in dev environment, we must set some env vars
    # in the pipeline.
    #
    # :nocov:
    if Dir.exist?("/mnt/secrets/tax-tribunals")
      Dir["/mnt/secrets/tax-tribunals/*"].each do |filepath|
        name = filepath.split('/')[-1]
        value = File.read(filepath)
        ENV[name] ||= value
        ENV[name] = value if ENV[name].eql? 'replace_this_at_build_time'
      end
    end
    # :nocov:

    config.middleware.use Rack::Attack

    config.middleware.use Rack::Brotli

    # This automatically adds id: :uuid to create_table in all future migrations
    config.active_record.primary_key = :uuid

    config.survey_link = 'https://www.smartsurvey.co.uk/s/TTExit20/'.freeze
    config.kickout_survey_link = 'https://www.smartsurvey.co.uk/s/TTExit20/'.freeze

    # This is the GDS-hosted homepage for our service, and the one with a `start` button
    config.gds_service_homepage_url = 'https://www.gov.uk/tax-tribunal'.freeze

    config.tax_tribunal_email = 'taxappeals@hmcts.gsi.gov.uk'
    config.tax_tribunal_phone = '0300 123 1024'

    config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 30).to_i
    config.x.session.warning_when_remaining = ENV.fetch('SESSION_WARNING_WHEN_REMAINING', 5).to_i

    config.x.cases.expire_in_days = ENV.fetch('EXPIRE_AFTER', 120).to_i
    config.x.users.expire_in_days = ENV.fetch('USERS_EXPIRE_AFTER', 30).to_i

    config.action_mailer.default_url_options = { host: ENV.fetch('EXTERNAL_URL') }

    config.x.address_lookup.endpoint = ENV.fetch('ADDRESS_LOOKUP_ENDPOINT', nil)
    config.x.address_lookup.api_key = ENV.fetch('ADDRESS_LOOKUP_API_KEY', nil)
    config.x.address_lookup.api_secret = ENV.fetch('ADDRESS_LOOKUP_API_SECRET', nil)

    if ENV['APP_INSIGHTS_INSTRUMENTATION_KEY']
      config.middleware.use ApplicationInsights::Rack::TrackRequest, ENV['APP_INSIGHTS_INSTRUMENTATION_KEY']
    end

    # config.middleware.use StrictTransportSecurityMiddleware # TEMP REMOVAL - 22 Jan

    config.maintenance_enabled = ENV.fetch('MAINTENANCE_ENABLED', 'false').downcase == 'true'
    config.maintenance_allowed_ips = ENV.fetch('MAINTENANCE_ALLOWED_IPS', '').split(',').map(&:strip)
    config.maintenance_end = ENV.fetch('MAINTENANCE_END', nil)

    config.dynatrace_ui_tracking_id = ENV.fetch('DYNATRACE_UI_TRACKING_ID', '')

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
