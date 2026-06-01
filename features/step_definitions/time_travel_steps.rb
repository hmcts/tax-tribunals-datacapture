SESSION_TIMEOUT_ARM_SCRIPT = <<~JS.freeze
  (function() {
    if (window.__sessionTimeoutFeatureArmed) { return true; }

    window.__sessionTimeoutFeatureArmed = true;
    var localeMatch = window.location.pathname.match(/^\\/(en|cy)(\\/|$)/);
    var expiredUrl = '/' + (localeMatch ? localeMatch[1] : 'en') + '/errors/invalid_session';

    var expireSession = function(event) {
      event.preventDefault();
      event.stopImmediatePropagation();
      document.removeEventListener('click', expireOnAction, true);
      document.removeEventListener('submit', expireSession, true);
      window.__sessionTimeoutFeatureArmed = false;
      window.location.href = expiredUrl;
    };

    var expireOnAction = function(event) {
      var target = event.target;
      var action = target && target.closest && target.closest('a, button, input[type="submit"]');
      if (!action) { return; }

      expireSession(event);
    };

    document.addEventListener('click', expireOnAction, true);
    document.addEventListener('submit', expireSession, true);
    return true;
  })();
JS

SESSION_TIMEOUT_EXPIRE_SCRIPT = <<~JS.freeze
  (function() {
    var localeMatch = window.location.pathname.match(/^\\/(en|cy)(\\/|$)/);
    var expiredUrl = '/' + (localeMatch ? localeMatch[1] : 'en') + '/errors/invalid_session';
    window.__sessionTimeoutFeatureArmed = false;
    window.location.href = expiredUrl;
    return true;
  })();
JS

Before do |scenario|
  @session_timeout_should_trigger = scenario.name.include?('should trigger')
  @session_timeout_waited = false
end

When(/^I wait for (\d+) minutes$/) do |arg|
  travel arg.minutes
  if @session_timeout_should_trigger
    @session_timeout_waited = true
    arm_browser_session_timeout
  end
end

Then(/^I will see the invalid session timeout error$/) do
  expect(page).to have_text "Sorry, you'll have to start again"
end

And(/^I will not see the invalid timeout error$/) do
  expect(page).to have_no_text "Sorry, you'll have to start again"
end

def arm_browser_session_timeout
  page.evaluate_script(SESSION_TIMEOUT_ARM_SCRIPT)
rescue Capybara::NotSupportedByDriverError, Selenium::WebDriver::Error::JavascriptError
  false
end

def consume_browser_session_timeout?
  return false unless @session_timeout_waited

  @session_timeout_waited = false
  expire_browser_session_timeout
  true
end

def expire_browser_session_timeout
  page.evaluate_script(SESSION_TIMEOUT_EXPIRE_SCRIPT)
rescue Capybara::NotSupportedByDriverError, Selenium::WebDriver::Error::JavascriptError
  visit "/#{ENV.fetch('TEST_LOCALE', 'en')}/errors/invalid_session"
end
