Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[*.png *.ico]
Rails.application.config.assets.precompile += %w[.svg .eot .woff .ttf .woff2 .woff]
Rails.application.config.assets.precompile += %w(
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
)

Rails.application.config.assets.precompile += %w(
  govuk-frontend/dist/govuk/all.scss
  govuk-frontend/dist/govuk/all.bundle.js
  govuk-frontend/dist/govuk/assets/fonts/*
  govuk-frontend/dist/govuk/assets/images/*
)

Rails.application.config.assets.configure do |env|
  env.context_class.class_eval do
    include JsAssetsHelper
  end
end
