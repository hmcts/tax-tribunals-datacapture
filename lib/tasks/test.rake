# These tasks are needed by Jenkins pipeline

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

def run_cucumber_with_retry(tags)
  system(
    'bundle', 'exec', 'cucumber', 'features/',
    '--tags', tags,
    *cucumber_retry_options
  )
end

namespace :test do
  task smoke: :environment do
    if run_cucumber_with_retry('@smoke')
      puts "Smoke test passed"
    else
      raise "Smoke tests failed"
    end
  end

  task functional: :environment do
    if system "bundle exec cucumber features/"
      puts "Functional test passed"
    else
      raise "Functional tests failed"
    end
  end
end
