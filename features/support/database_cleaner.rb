DatabaseCleaner.strategy = :truncation

database_host = ENV['DB_HOST'].to_s
database_name = ENV['DB_NAME'].to_s

preview_database = database_host == 'tax-tribunals-preview.postgres.database.azure.com' &&
                   database_name.match?(/\Apr-\d+\z/)
aat_database = database_host == 'tax-tribunals-infrastructure-aat.postgres.database.azure.com' &&
                          !database_name.empty?

if preview_database || aat_database
  DatabaseCleaner.allow_remote_database_url = true
else
  DatabaseCleaner.url_allowlist = ['postgresql://postgres@localhost/tt-datacapture_test', 'postgres://postgres@localhost/tt-test-postgres']
end

Before do
  DatabaseCleaner.clean
end
