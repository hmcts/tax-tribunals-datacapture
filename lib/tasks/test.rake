# Rake::Task[:test].clear

task test: :environment do
  # Code to run your tests
  Rake::Task['rubocop'].invoke
  # Rake::Task['brakeman'].invoke
  Rake::Task['rspec'].invoke
  # Rake::Task['cucumber'].invoke
end

namespace :test do
  task :smoke do
    # Start the database server (example for PostgreSQL)
    puts "Starting the database server..."
    system("sudo service postgresql start") || raise("Failed to start the database server")

    # Set up the test database
    puts "Setting up the test database..."
    system("bundle exec rake db:test:prepare") || raise("Failed to set up the test database")

    # Run the smoke tests
    puts "Running smoke tests..."
    if system("bundle exec cucumber features/ --tags @smoke")
      puts "Smoke test passed"
    else
      raise "Smoke tests failed"
    end
  end

  task :functional do
    if system "bundle exec cucumber features/"
      puts "Functional test passed"
    else
      raise "Functional tests failed"
    end
  end
end
