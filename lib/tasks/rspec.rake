require 'English'
task rspec: :environment do
  unless system("rspec --format RspecJunitFormatter --out tmp/test/rspec.xml")
    raise "Rspec testing failed #{$CHILD_STATUS}"
  end
end
