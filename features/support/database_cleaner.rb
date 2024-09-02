DatabaseCleaner.strategy = :truncation
# DatabaseCleaner.url_allowlist = ['postgresql://postgres@localhost/tt-datacapture_test', 'postgres://postgres@localhost/tt-test-postgres']
DatabaseCleaner.url_allowlist = ['postgresql://localhost@db/tt-datacapture_test']

Before do
  DatabaseCleaner.clean
end