DatabaseCleaner.strategy = :truncation

preview_database = ENV['DB_HOST'] == 'tax-tribunals-preview.postgres.database.azure.com' &&
                   ENV['DB_NAME'].to_s.match?(/\Apr-\d+\z/)

if preview_database
  DatabaseCleaner.allow_remote_database_url = true
else
  DatabaseCleaner.url_allowlist = ['postgresql://postgres@localhost/tt-datacapture_test', 'postgres://postgres@localhost/tt-test-postgres']
end

Before do
  DatabaseCleaner.clean
end
