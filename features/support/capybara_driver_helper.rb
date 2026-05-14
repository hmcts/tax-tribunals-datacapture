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
  chrome_options = Selenium::WebDriver::Chrome::Options.new(
    args: ['--headless=new', '--disable-gpu', '--disable-dev-shm-usage', '--no-sandbox', '--window-size=1366,768', '--disable-blink-features=AutomationControlled', '--disable-extensions', '--disable-plugins', '--disable-background-timer-throttling', '--disable-renderer-backgrounding']
  )
  chrome_options.page_load_strategy = page_load_strategy
  chrome_options.timeouts = browser_timeouts
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

#Capybara.register_driver :headless_test do |app|
# chrome_options = Selenium::WebDriver::Chrome::Options.new
# chrome_options.add_argument('--headless=new') # Use the updated headless engine  chrome_options.add_argument('--disable-gpu')
# chrome_options.add_argument('--window-size=1366,768')
  # Critical for CI/CDP stability:  chrome_options.add_argument('--disable-search-engine-choice-screen')
# chrome_options.add_argument('--no-sandbox')
# chrome_options.add_argument('--disable-dev-shm-usage')
  # Core stability fixes for CDP and DOM handling
# chrome_options.add_argument('--disable-gpu')
  # Prevent automation detection and reduce interference
# chrome_options.add_argument('--disable-blink-features=AutomationControlled') #Reduces detection of automation, improving test stability
# chrome_options.add_argument('--disable-extensions')
# chrome_options.add_argument('--disable-plugins')

  # Reduce DOM mutation issues from sync operations
# chrome_options.add_argument('--disable-sync') #Prevents background sync operations that can mutate the DOM unexpectedly
# chrome_options.add_argument('--disable-default-apps')

  # Performance and CI-specific flags
# chrome_options.add_argument('--disable-search-engine-choice-screen')
# chrome_options.add_argument('--disable-preconnect')
# chrome_options.add_argument('--disable-background-networking')

  # Disable features that can cause stale element references. Keeps the browser process in foreground, reducing DOM detachment issues
# chrome_options.add_argument('--disable-renderer-backgrounding')
# chrome_options.add_argument('--disable-backgrounding-occluded-windows')

  # Disable logging/metrics that can slow things down. Lightweight mode for faster execution
# chrome_options.add_argument('--metrics-recording-only')

  # Disable USB/Bluetooth to reduce noise
# chrome_options.add_argument('--disable-usb-transfer-info') #to reduce interference

  #Additional options to prevent DOM instability and inspector errors
# chrome_options.add_argument('--disable-features=VizDisplayCompositor') # Disables the Viz display compositor to prevent rendering-related DOM issues
# chrome_options.add_argument('--disable-ipc-flooding-protection') # Prevents IPC flooding protection that can interfere with DOM operations
# chrome_options.add_argument('--disable-web-security') # Disables web security features that might cause unexpected DOM changes
# chrome_options.add_argument('--disable-background-timer-throttling') # Prevents throttling of background timers that can affect DOM updates
# chrome_options.add_argument('--disable-renderer-accessibility') # Disables accessibility features in the renderer to reduce potential interference
# chrome_options.add_argument('--disable-background-networking') # Disables background networking to prevent unexpected DOM changes
# chrome_options.add_argument('--disable-component-extensions-with-background-pages') # Disables extensions with background pages that can mutate DOM
# chrome_options.add_argument('--disable-ipc-flooding-protection') # Additional IPC protection disable (if not already present)
# chrome_options.add_argument('--no-first-run') # Skips first-run setup that can cause DOM issues
# chrome_options.add_argument('--disable-default-apps') # Additional disable for default apps (if not already present)


# driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)

  # Add wait conditions to handle async operations. Gives Selenium 5 seconds to find elements before throwing "not found" errors, reducing stale element references
# driver.browser.manage.timeouts.implicit_wait = 5  # 5 second implicit wait

# driver
#end

Capybara.register_driver :chrome do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.page_load_strategy = page_load_strategy
  chrome_options.timeouts = browser_timeouts
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara::Screenshot.register_driver(:headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

#Capybara::Screenshot.register_driver(:headless_test) do |driver, path|
# driver.browser.save_screenshot(path)
#end

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

#............. Sauce Labs .............#

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
