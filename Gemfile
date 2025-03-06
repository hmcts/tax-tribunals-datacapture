source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.2'

gem 'azure_env_secrets', git: 'https://github.com/hmcts/azure_env_secrets.git', tag: 'v1.0.1'
gem 'bootsnap',                        '~> 1.16', require: false
gem 'devise'
gem "valid_email2"
gem 'glimr-api-client', github: 'ministryofjustice/glimr-api-client', tag: 'v0.4.1'
gem 'govuk_design_system_formbuilder'
gem 'govuk_notify_rails', '~> 3.0'
gem 'jquery-rails'
gem 'nokogiri', '>= 1.16.2'
gem 'pg'
gem 'pry-rails'
gem 'puma'
gem 'rack-attack',                     '~> 6.7.0'
gem 'rackup',                          '1.0.1', require: false
gem 'rails',                           '~> 8.0.0'
gem 'responders'
gem 'sanitize'
gem 'sassc-rails',                     '~> 2.1.2'
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'strong_password',                 '~> 0.0.8'
gem 'uglifier'
gem 'virtus'
gem 'zendesk_api',                     '~> 1.28'
gem 'application_insights',            '~> 0.5.6'
gem 'sprockets'
gem 'rest-client'
gem 'ostruct'
gem 'rack-cors'
gem 'rack-brotli'
gem 'brotli'

gem 'rexml', '>= 3.3.6'
gem 'webrick', '>= 1.8.2'

# To fix ruby 3.3.3 gemsepec file issue with this gem
gem 'net-pop', github: 'ruby/net-pop'

# Admin
gem 'sidekiq', '8.0.0'
gem 'sidekiq-batch'
gem 'sidekiq_alive'

# PDF generation
gem "select2-rails"
gem 'grover'

# Azure blob storage
gem 'azure-storage-blob', '~> 2'
gem 'mimemagic', '~> 0.4.0'

# Loading envs from settings
gem 'config'


source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license', '0.1.1.2.1739399027284447558325915053311580324856.4'
end

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'hashdiff', '>= 0.4.0'
  gem 'web-console'
  gem 'listen'
end

group :development, :test do
  gem 'actionpack'
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'faker'
  gem 'launchy'
  gem 'mutant-rspec'
  gem 'bundler-audit'
  gem 'pry-byebug'
  gem 'timecop'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance'
  gem 'rubocop-rspec_rails'
  gem 'rubocop-rails'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
end

group :test do
  gem 'brakeman'
  gem 'apparition'
  gem 'capybara'
  gem 'cucumber-rails', '~> 3.0', require: false
  gem 'capybara-screenshot'
  gem 'database_cleaner-active_record'
  gem 'geckodriver-helper', '~> 0.24.0'
  gem 'factory_bot_rails'
  gem 'phantomjs'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter', '~> 0.6.0'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.22.0'
  gem 'simplecov-rcov'
  gem 'site_prism'
  gem 'webmock'
  gem 'rspec-sidekiq'
end
