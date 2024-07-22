DatabaseCleaner.strategy = :truncation
DatabaseCleaner.url_allowlist = ['postgresql://postgres@db/tax-tribunals-datacapture', 'postgresql://postgres@localhost/tt-datacapture_test']

Before do
  DatabaseCleaner.clean
end