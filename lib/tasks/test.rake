# These tasks are needed by Jenkins pipeline

task test: :environment do
  unless system "bundle exec rubocop"
    raise "Rubocop failed"
  end

  unless system("rspec --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$?}"
  end
end

namespace :test do
  task smoke: :environment do
    if system "bundle exec cucumber features/ --tags @smoke"
      puts "Smoke test passed"
    else
      raise "Smoke tests failed"
    end
  end

  task functional: :environment do
    retry_attempts = ENV.fetch('CUCUMBER_RETRY_ATTEMPTS', '1')
    retry_total = ENV.fetch('CUCUMBER_RETRY_TOTAL', '5')

    if system(
      'bundle', 'exec', 'cucumber', 'features/',
      '--tags', 'not @smoke',
      '--retry', retry_attempts,
      '--retry-total', retry_total
    )
      puts "Functional test passed"
    else
      raise "Functional tests failed"
    end
  end
end
