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
  expected_url = Rails.application.config.survey_link
  expect(page.current_url).to start_with(expected_url)
end

# rubocop:disable Lint/AmbiguousRegexpLiteral
Given /^I take a screenshot of (.*)$/ do |journey|
  screenshot_closure_application(journey)
end
# rubocop:enable Lint/AmbiguousRegexpLiteral
