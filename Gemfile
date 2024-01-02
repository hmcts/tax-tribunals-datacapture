source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'azure_env_secrets', git: 'https://github.com/hmcts/azure_env_secrets.git', tag: 'v1.0.1'
gem 'bootsnap',                        '~> 1.16', require: false
gem 'devise'
gem "valid_email2",                    '3.7.0'
gem 'glimr-api-client', github: 'ministryofjustice/glimr-api-client', tag: 'v0.4.1'
gem 'govuk_design_system_formbuilder', '~> 4'
gem 'govuk_notify_rails',              '~> 2.1'
gem 'jquery-rails',                    '4.6.0'
gem 'nokogiri'
gem 'pg'
gem 'pry-rails'
gem 'puma',                            '~> 6'
gem 'rack-attack',                     '~> 6.7.0'
gem 'rails',                           '~> 7.1.2'
gem 'responders',                      '3.1.1'
gem 'sanitize'
gem 'sassc-rails',                     '~> 2.1.2'
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'strong_password',                 '~> 0.0.8'
gem 'uglifier',                        '4.2.0'
gem 'virtus',                          '1.0.5'
gem 'zendesk_api',                     '~> 1.28'
gem 'application_insights',            '~> 0.5.6'
gem 'sprockets',                       '3.7.2'
gem "sprockets-rails"
gem 'rest-client',                     '2.1.0'

# Admin
gem 'sidekiq',                         '6.5.12'
gem 'sidekiq-batch',                   '0.1.9'
gem 'sidekiq_alive',                   '2.3.1'

# PDF generation
gem "select2-rails",                   '4.0.13'
gem 'grover'

# Azure blob storage
gem 'azure-storage-blob', '~> 2'
gem 'mimemagic', '~> 0.4.0'

# Virus scanning
gem 'clamby'

source 'https://oss:Q7U7p2q2XlpY45kwqjCpXLIPf122rjkR@gem.mutant.dev' do
  gem 'mutant-license',                '0.1.1.2.1739399027284447558325915053311580324856.4'
end

group :production do
  gem 'lograge',                       '0.14.0'
  gem 'logstash-event',                '1.2.02'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller',             '1.0.0'
  gem 'i18n-debug',                    '1.2.0'
  gem 'listen'
  gem 'hashdiff', '>= 0.4.0',          '1.0.1'
  gem 'web-console',                   '4.2.1'
  gem 'spring',                        '4.1.3'
  gem 'spring-commands-rspec',         '1.0.4'
  gem "spring-commands-cucumber",      '1.0.1'
end

group :development, :test do
  gem 'byebug', '11.1.3', platform: :mri
  gem 'dotenv-rails'
  gem 'faker',                         '3.2.2'
  gem 'launchy',                       '2.5.2'
  gem 'mutant-rspec',                  '0.11.26'
  gem 'bundler-audit'
  gem 'pry-byebug'
  gem 'timecop', '0.9.8'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'brakeman'
  gem 'apparition', '0.6.0'
  gem 'capybara'
  gem 'cucumber-rails', '~> 3.0', require: false
  gem 'capybara-screenshot'
  gem 'database_cleaner-active_record'
  gem 'geckodriver-helper', '~> 0.24.0'
  gem 'factory_bot_rails'
  gem 'phantomjs', '2.1.1.0'
  gem 'poltergeist', '~> 1.18', '>= 1.18.1'
  gem 'rails-controller-testing', '1.0.5'
  gem 'rspec_junit_formatter', '~> 0.6.0'
  gem 'selenium-webdriver'
  gem 'simplecov', '0.22.0', require: false
  gem 'simplecov-rcov', '0.3.3'
  gem 'site_prism', '4.0.3'
  gem 'webmock', '3.19.1', require: false
  gem 'rspec-sidekiq', '4.1.0'
end
