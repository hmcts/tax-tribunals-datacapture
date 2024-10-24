Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://appeal-tax-tribunal.service.gov.uk'
    resource '*',
             headers: :any,
             methods: [:get, :post, :put, :patch, :delete, :options]
  end
end