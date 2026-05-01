Selenium::WebDriver.logger.level = :error

def browser_timeouts
  timeout = ENV.fetch('CAPYBARA_PAGE_LOAD_TIMEOUT', 30).to_i * 1000
  { page_load: timeout, script: timeout }
end

def page_load_strategy
  ENV.fetch('CAPYBARA_PAGE_LOAD_STRATEGY', 'normal').to_sym
end

def default_capybara_driver
  return ENV.fetch('DRIVER').to_sym if ENV.fetch('DRIVER', nil).present?

  ENV.fetch('TEST_BROWSER', nil) == 'chrome_local' ? :headless : :firefox
end

Capybara.configure do |config|
  config.default_driver = default_capybara_driver
  config.default_max_wait_time = 30
  config.match = :prefer_exact
  config.exact = true
  config.visible_text_only = true
end

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, js_errors: false)
end

Capybara.register_driver :headless do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu', 'window-size=1366,768'])
  chrome_options.page_load_strategy = page_load_strategy
  chrome_options.timeouts = browser_timeouts
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.page_load_strategy = page_load_strategy
  chrome_options.timeouts = browser_timeouts
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara::Screenshot.register_driver(:headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.page_load_strategy = page_load_strategy
  options.timeouts = browser_timeouts
  options.args << '--headless'
  options.args << '--disable-gpu'
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

# ............. Sauce Labs .............#

Capybara.register_driver :chrome_saucelabs do |app|
  browser = { browserName: "chrome", name: "WIN_CHROME_LATEST", platform: "Windows 10", version: "latest" }
  Capybara::Selenium::Driver.new(app, browser: :remote,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub", desired_capabilities: browser)
end

Capybara.register_driver :ms_edge_saucelabs do |app|
  browser = { browserName: "MicrosoftEdge", name: "EDGE_LATEST", platform: "Windows 10", version: "latest" }
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :ff_saucelabs do |app|
  browser = { browserName: "firefox", name: "FIREFOX_LATEST", platform: "Windows 10", version: "latest", acceptInsecureCerts: true }
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

# Doesn't go past the home page
Capybara.register_driver :safari_saucelabs do |app|
  capabilities = {
    browser: 'safari',
      version: 'latest',
      platform: 'macOS 10.15',
      "sauce:options" => {
        screen_resolution: '2360x1770'
      }
  }
  caps = Selenium::WebDriver::Remote::Capabilities.send('safari', capabilities)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :ie_saucelabs do |app|
  capabilities = {
    browser: 'internet_explorer',
      version: 'latest',
      platform: 'Windows 10'
  }
  caps = Selenium::WebDriver::Remote::Capabilities.send('internet_explorer', capabilities)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
puts "Using Capybara driver: #{Capybara.default_driver}"
puts "Using page load strategy: #{page_load_strategy}"

test_url = ENV.fetch('CAPYBARA_APP_HOST', nil) || ENV.fetch('TEST_URL', nil) || ENV.fetch('APP_HOST', nil)

if test_url.present?
  Capybara.run_server = false
  Capybara.always_include_port = false
  Capybara.app_host = test_url.chomp('/')
  puts "Using Capybara app host: #{Capybara.app_host}"
else
  Capybara.always_include_port = true
  Capybara.app_host = "http://#{ENV.fetch('HOSTNAME', 'localhost')}"
  Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME', 'localhost'))
  Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', '3001') unless ENV['CAPYBARA_SERVER_PORT'] == 'random'
end
