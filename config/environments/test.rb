require "active_support/core_ext/integer/time"

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV["CI"].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # So we can always expect the same value in tests
  config.action_mailer.default_url_options = { host: 'https://tax.justice.uk' }

  # NB: Because of the way the form builder works, and hence the
  # gov.uk elements formbuilder, exceptions will not be raised for
  # missing translations of model attribute names. The form will
  # get the constantized attribute name itself, in form labels.
  config.i18n.raise_on_missing_translations = true

  config.assets.css_compressor = false

  config.enable_reloading = false

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  config.action_controller.raise_on_missing_callback_actions = false
  config.action_controller.raise_on_open_redirects = false

end

Rails.application.routes.default_url_options[:locale] = I18n.default_locale
