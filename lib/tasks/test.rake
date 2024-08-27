# Rake::Task[:test].clear

task test: :environment do
  # Code to run your tests
  Rake::Task['rubocop'].invoke
  # Rake::Task['brakeman'].invoke
  Rake::Task['rspec'].invoke
  # Rake::Task['cucumber'].invoke
end

namespace :test do
  task smoke: :environment do
    if system "bundle exec cucumber features/  --tags @smoke"
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
