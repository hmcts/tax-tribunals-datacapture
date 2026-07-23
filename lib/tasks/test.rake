# These tasks are needed by Jenkins pipeline

require 'fileutils'

task test: :environment do
  unless system "bundle exec rubocop"
    raise "Rubocop failed"
  end

  unless system("rspec --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$?}"
  end
end

def cucumber_retry_options
  [
    '--retry', ENV.fetch('CUCUMBER_RETRY_ATTEMPTS', '1'),
    '--retry-total', ENV.fetch('CUCUMBER_RETRY_TOTAL', '5'),
    '--no-strict-flaky'
  ]
end

def cucumber_report_options(suite)
  return [] if ENV['CI'].to_s.empty?

  report_directory = File.join('tmp/test/cucumber', suite)
  FileUtils.mkdir_p(report_directory)

  ['--format', 'pretty', '--format', 'junit', '--out', report_directory]
end

def run_cucumber_with_retry(tags, suite)
  system(
    'bundle', 'exec', 'cucumber', 'features/',
    '--tags', tags,
    *cucumber_report_options(suite),
    *cucumber_retry_options
  )
end

def skip_deployed_test_suite?
  aat_environment = ENV.fetch('ENVIRONMENT_NAME', '').casecmp?('aat')
  preview_url = ENV.fetch('TEST_URL', '').match?(%r{\Ahttps://tax-tribunals-application-pr-\d+\.preview\.platform\.hmcts\.net/?\z})

  aat_environment && !preview_url
end

namespace :test do
  # The environment is invoked inside each task so AAT can exit before Rails
  # initialisation and without database configuration.
  # rubocop:disable Rails/RakeEnvironment
  desc 'Run smoke tests unless the deployed environment is AAT'
  task :smoke do
    if skip_deployed_test_suite?
      puts 'Skipping smoke tests for AAT'
      next
    end

    # Jenkins smoke tests target the deployed URL and must not initialise a
    # local database merely to load cucumber-rails.
    ENV['SKIP_TEST_DATABASE'] = 'true' if ENV['TEST_URL'].to_s != ''
    Rake::Task[:environment].invoke

    if run_cucumber_with_retry('@smoke', 'smoke')
      puts "Smoke test passed"
    else
      raise "Smoke tests failed"
    end
  end

  desc 'Run functional tests unless the deployed environment is AAT'
  task :functional do
    if skip_deployed_test_suite?
      puts 'Skipping functional tests for AAT'
      next
    end

    Rake::Task[:environment].invoke

    if run_cucumber_with_retry('not @smoke', 'functional')
      puts "Functional test passed"
    else
      raise "Functional tests failed"
    end
  end
  # rubocop:enable Rails/RakeEnvironment
end
