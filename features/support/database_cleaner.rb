DatabaseCleaner.strategy = :truncation
DatabaseCleaner.url_allowlist = ['postgresql://postgres@db/tax-tribunals-datacapture', 'postgresql://postgres@db/tt-datacapture_test']

Before do
  DatabaseCleaner.clean
end