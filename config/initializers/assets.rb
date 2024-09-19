Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[*.png *.ico]
Rails.application.config.assets.precompile += %w[.svg .eot .woff .ttf .woff2 .woff]

Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/all.css']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/govuk-frontend.min.js']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/assets/images/favicon.ico']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/assets/images/favicon.svg']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/assets/images/govuk-icon-mask.svg']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/assets/images/govuk-icon-180.png']
Rails.application.config.assets.precompile += ['govuk-frontend/dist/govuk/assets/fonts/*']

Rails.application.config.assets.configure do |env|
  env.context_class.class_eval do
    include JsAssetsHelper
  end
end
