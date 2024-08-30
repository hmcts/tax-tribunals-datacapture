DatabaseCleaner.strategy = :truncation
DatabaseCleaner.url_allowlist = ['postgresql://localhost@db/tt-datacapture_test']

Before do
  DatabaseCleaner.clean
end