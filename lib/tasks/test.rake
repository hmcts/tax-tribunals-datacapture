# Rake::Task[:test].clear

task test: :environment do
  # Code to run your tests
  Rake::Task['rubocop'].invoke
  # Rake::Task['brakeman'].invoke
  Rake::Task['rspec'].invoke
  Rake::Task['cucumber'].invoke
end

# The following is the default task to run if none specified, so:
#   `bundle exec rake`
# will be equivalent to:
#   `bundle exec rake test`
#
# task(:default).prerequisites.clear << task('test')
  