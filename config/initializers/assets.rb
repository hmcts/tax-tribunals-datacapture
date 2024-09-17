Rails.application.config.assets.version = '1.1'
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.precompile += %w[*.png *.ico *.svg *.eot *.woff *.ttf *.woff2 *.woff]

Rails.application.config.assets.precompile += %w(
  govuk-frontend/dist/govuk/all.scss
  govuk-frontend/dist/govuk/all.bundle.js
)

Rails.application.config.assets.configure do |env|
  env.context_class.class_eval do
    include JsAssetsHelper
  end
end
