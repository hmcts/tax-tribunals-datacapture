# Rake::Task[:test].clear

task test: :environment do
  unless system("rspec --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$?}"
  end
  # Code to run your tests
  # Rake::Task['rubocop'].invoke
  # Rake::Task['brakeman'].invoke
  # Rake::Task['rspec'].invoke
  # Rake::Task['cucumber'].invoke
end

namespace :test do
  task :smoke do
    puts "No smoke tests yet"
  end

  task :functional do
    puts "No functional tests yet"
  end
end
