Given("I complete a valid closure application") do
  retry_transient_inspector_node_error { complete_valid_closure_application }
end

Given("I complete a valid appeal application") do
  retry_transient_inspector_node_error { complete_valid_appeal_application }
end

Then("I should be told that the application has been successfully submitted") do
  retry_transient_inspector_node_error(reset_session: false) do
    expect(page).to have_css('h1', text: I18n.t('dictionary.CYA_CONFIRMATION.confirmation.show.page_title'))
  end
end

When("I can access the finish survey") do
  retry_transient_inspector_node_error(reset_session: false) do
    expect(page).to have_button(I18n.t('dictionary.START_FINISH.finish'))
  end
end

# rubocop:disable Lint/AmbiguousRegexpLiteral
Given /^I take a screenshot of (.*)$/ do |journey|
  screenshot_closure_application(journey)
end
# rubocop:enable Lint/AmbiguousRegexpLiteral
