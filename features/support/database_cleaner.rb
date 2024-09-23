DatabaseCleaner.strategy = :truncation
DatabaseCleaner.url_allowlist = ['postgresql://postgres@localhost/tt-datacapture_test', 'postgres://postgres@localhost/tt-test-postgres']

Before do
  DatabaseCleaner.clean
end