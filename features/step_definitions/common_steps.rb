Given("I submit that I am an individual") do
  next if consume_pending_browser_session_timeout?

  current_type_page.submit_individual
end

Given("I submit that I am a company") do
  next if consume_pending_browser_session_timeout?

  current_type_page.submit_company
end

Given("I submit that I am an other") do
  next if consume_pending_browser_session_timeout?

  current_type_page.submit_other
end

Given("I click the back button") do
  back
end

When("I click on save and come back later") do
  save_and_come_back
end

When("I click the continue button") do
  continue_or_save_continue
end

Given('I select english only') do
  select_language_page.select_english
end

def current_type_page
  return representative_type_page if page.current_path&.end_with?('/steps/details/representative_type')

  taxpayer_type_page
end

def consume_pending_browser_session_timeout?
  respond_to?(:consume_browser_session_timeout?, true) && consume_browser_session_timeout?
end
