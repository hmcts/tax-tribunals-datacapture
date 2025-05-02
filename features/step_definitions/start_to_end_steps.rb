Given("I complete a valid closure application") do
  complete_valid_closure_application
end

Given("I complete a valid appeal application") do
  complete_valid_appeal_application
end

Then("I should be told that the application has been successfully submitted") do
  expect(confirmation_page.content).to have_case_submitted_header
end

When("I click Finish") do
  confirmation_page.finish
end

Then("I should be on the Smart Survey link") do
  expect(page).to have_text "Thank you for taking your time to tell us what you think about the Tax Tribunal online service."
  WebMock.reset!
  WebMock.allow_net_connect!(net_http_connect_on_start: true, allow_localhost: true)
end

# rubocop:disable Lint/AmbiguousRegexpLiteral
Given /^I take a screenshot of (.*)$/ do |journey|
  screenshot_closure_application(journey)
end
# rubocop:enable Lint/AmbiguousRegexpLiteral
