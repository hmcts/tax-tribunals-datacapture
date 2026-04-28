Selenium::WebDriver.logger.level = :error

Capybara.configure do |config|
  driver = ENV['DRIVER']&.to_sym || :firefox
  config.default_driver = driver
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
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :headless_test do |app|
  chrome_options = Selenium::WebDriver::Chrome::Options.new
  chrome_options.add_argument('--headless=new') # Use the updated headless engine  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--window-size=1366,768')
  # Critical for CI/CDP stability:  chrome_options.add_argument('--disable-search-engine-choice-screen')
  chrome_options.add_argument('--no-sandbox')
  chrome_options.add_argument('--disable-dev-shm-usage')
  # Core stability fixes for CDP and DOM handling
  chrome_options.add_argument('--disable-gpu')
  # Prevent automation detection and reduce interference
  chrome_options.add_argument('--disable-blink-features=AutomationControlled') #Reduces detection of automation, improving test stability
  chrome_options.add_argument('--disable-extensions')
  chrome_options.add_argument('--disable-plugins')

  # Reduce DOM mutation issues from sync operations
  chrome_options.add_argument('--disable-sync') #Prevents background sync operations that can mutate the DOM unexpectedly
  chrome_options.add_argument('--disable-default-apps')

  # Performance and CI-specific flags
  chrome_options.add_argument('--disable-search-engine-choice-screen')
  chrome_options.add_argument('--disable-preconnect')
  chrome_options.add_argument('--disable-background-networking')

  # Disable features that can cause stale element references. Keeps the browser process in foreground, reducing DOM detachment issues
  chrome_options.add_argument('--disable-renderer-backgrounding')
  chrome_options.add_argument('--disable-backgrounding-occluded-windows')

  # Disable logging/metrics that can slow things down. Lightweight mode for faster execution
  chrome_options.add_argument('--metrics-recording-only')

  # Disable USB/Bluetooth to reduce noise
  chrome_options.add_argument('--disable-usb-transfer-info') #to reduce interference

  #Additional options to prevent DOM instability and inspector errors
  chrome_options.add_argument('--disable-features=VizDisplayCompositor') # Disables the Viz display compositor to prevent rendering-related DOM issues
  chrome_options.add_argument('--disable-ipc-flooding-protection') # Prevents IPC flooding protection that can interfere with DOM operations
  chrome_options.add_argument('--disable-web-security') # Disables web security features that might cause unexpected DOM changes
  chrome_options.add_argument('--disable-background-timer-throttling') # Prevents throttling of background timers that can affect DOM updates
  chrome_options.add_argument('--disable-renderer-accessibility') # Disables accessibility features in the renderer to reduce potential interference
  chrome_options.add_argument('--disable-background-networking') # Disables background networking to prevent unexpected DOM changes
  chrome_options.add_argument('--disable-component-extensions-with-background-pages') # Disables extensions with background pages that can mutate DOM
  chrome_options.add_argument('--disable-ipc-flooding-protection') # Additional IPC protection disable (if not already present)
  chrome_options.add_argument('--no-first-run') # Skips first-run setup that can cause DOM issues
  chrome_options.add_argument('--disable-default-apps') # Additional disable for default apps (if not already present)


  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)

  # Add wait conditions to handle async operations. Gives Selenium 5 seconds to find elements before throwing "not found" errors, reducing stale element references
  driver.browser.manage.timeouts.implicit_wait = 5  # 5 second implicit wait

  driver
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara::Screenshot.register_driver(:headless) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara::Screenshot.register_driver(:headless_test) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.register_driver :headless_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('--headless=new') # Use the updated headless engine  chrome_options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1366,768')
  # Critical for CI/CDP stability:  chrome_options.add_argument('--disable-search-engine-choice-screen')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  # Core stability fixes for CDP and DOM handling
  options.add_argument('--disable-gpu')
  # Prevent automation detection and reduce interference
  options.add_argument('--disable-blink-features=AutomationControlled') #Reduces detection of automation, improving test stability
  options.add_argument('--disable-extensions')
  options.add_argument('--disable-plugins')

  # Reduce DOM mutation issues from sync operations
  options.add_argument('--disable-sync') #Prevents background sync operations that can mutate the DOM unexpectedly
  options.add_argument('--disable-default-apps')

  # Performance and CI-specific flags
  options.add_argument('--disable-search-engine-choice-screen')
  options.add_argument('--disable-preconnect')
  options.add_argument('--disable-background-networking')

  # Disable features that can cause stale element references. Keeps the browser process in foreground, reducing DOM detachment issues
  options.add_argument('--disable-renderer-backgrounding')
  options.add_argument('--disable-backgrounding-occluded-windows')

  # Disable logging/metrics that can slow things down. Lightweight mode for faster execution
  options.add_argument('--metrics-recording-only')

  # Disable USB/Bluetooth to reduce noise
  options.add_argument('--disable-usb-transfer-info') #to reduce interference

  #Additional options to prevent DOM instability and inspector errors
  options.add_argument('--disable-features=VizDisplayCompositor') # Disables the Viz display compositor to prevent rendering-related DOM issues
  options.add_argument('--disable-ipc-flooding-protection') # Prevents IPC flooding protection that can interfere with DOM operations
  options.add_argument('--disable-web-security') # Disables web security features that might cause unexpected DOM changes
  options.add_argument('--disable-background-timer-throttling') # Prevents throttling of background timers that can affect DOM updates
  options.add_argument('--disable-renderer-accessibility') # Disables accessibility features in the renderer to reduce potential interference
  options.add_argument('--disable-background-networking') # Disables background networking to prevent unexpected DOM changes
  options.add_argument('--disable-component-extensions-with-background-pages') # Disables extensions with background pages that can mutate DOM
  options.add_argument('--disable-ipc-flooding-protection') # Additional IPC protection disable (if not already present)
  options.add_argument('--no-first-run') # Skips first-run setup that can cause DOM issues
  options.add_argument('--disable-default-apps') # Additional disable for default apps (if not already present)


  driver = Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)

  # Add wait conditions to handle async operations. Gives Selenium 5 seconds to find elements before throwing "not found" errors, reducing stale element references
  driver.browser.manage.timeouts.implicit_wait = 5  # 5 second implicit wait

  driver
end

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.args << '--headless'
  options.args << '--disable-gpu'
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.register_driver :safari do |app|
  Capybara::Selenium::Driver.new(app, browser: :safari)
end

#............. Sauce Labs .............#

Capybara.register_driver :chrome_saucelabs do |app|
  browser = {:browserName=>"chrome", :name=>"WIN_CHROME_LATEST", :platform=>"Windows 10", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub", desired_capabilities: browser)
end

Capybara.register_driver :ms_edge_saucelabs do |app|
  browser = {:browserName=>"MicrosoftEdge", :name=>"EDGE_LATEST", :platform=>"Windows 10", :version=>"latest"}
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: browser,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.register_driver :ff_saucelabs do |app|
  browser = {:browserName=>"firefox", :name=>"FIREFOX_LATEST", :platform=>"Windows 10", :version=>"latest", :acceptInsecureCerts=>true}
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
        screen_resolution: '2360x1770',
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
      platform: 'Windows 10',
  }
  caps = Selenium::WebDriver::Remote::Capabilities.send('internet_explorer', capabilities)
  Capybara::Selenium::Driver.new(app, browser: :remote, desired_capabilities: caps,
url: "http://#{ENV.fetch('SAUCE_USERNAME', nil)}:#{ENV.fetch('SAUCE_ACCESS_KEY', nil)}@ondemand.eu-central-1.saucelabs.com:80/wd/hub")
end

Capybara.javascript_driver = Capybara.default_driver
Capybara.current_driver = Capybara.default_driver
# To run tests on production url and for running any saucelab driver. Replace line 93 and 94 with this:
# Capybara.always_include_port = false
# Capybara.app_host = "https://appeal-tax-tribunal.service.gov.uk"
Capybara.always_include_port = true
Capybara.app_host = ENV.fetch('CAPYBARA_APP_HOST', "http://#{ENV.fetch('HOSTNAME', 'localhost')}")
Capybara.server_host = ENV.fetch('CAPYBARA_SERVER_HOST', ENV.fetch('HOSTNAME', 'localhost'))
Capybara.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', '3001') unless ENV['CAPYBARA_SERVER_PORT'] == 'random'
