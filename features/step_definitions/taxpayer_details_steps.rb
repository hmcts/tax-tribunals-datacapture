Given("I navigate to the closure taxpayer details page as a taxpayer") do
  navigate_to_closure_taxpayer_details_page(:taxpayer_user_type)
end

Given("I navigate to the closure taxpayer details page as a representative") do
  navigate_to_closure_taxpayer_details_page(:representative_user_type)
end

When("I successfully submit taxpayers details") do
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_taxpayer_details
end

When("I submit a blank taxpayers details form") do
  expect(taxpayer_details_page.content).to have_header
  continue_or_save_continue
end

Then("I am taken to the send taxpayer copy page") do
  expect(page).to have_css('h1', text: I18n.t('check_answers.send_taxpayer_copy.question'))
end

Then("I am shown all the taxpayer details errors") do
  [
    I18n.t('dictionary.blank_first_name'),
    I18n.t('dictionary.blank_last_name'),
    I18n.t('dictionary.blank_address'),
    I18n.t('dictionary.blank_city'),
    I18n.t('dictionary.blank_postcode'),
    I18n.t('dictionary.blank_country'),
    I18n.t('dictionary.blank_email')
  ].each do |error_message|
    expect(page).to have_css('.govuk-error-summary', text: error_message)
  end
end

Then("I am on the taxpayer details page") do
  expect(taxpayer_details_page.content).to have_header
end

When(/^I submit a taxpayers details form with an invalid email$/) do
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_some_taxpayer_details
end

Then(/^I am shown an invalid email error$/) do
  expect(taxpayer_details_page.content.input_field[6].input_error.text).to have_text(I18n.t('dictionary.invalid_email'))
end

When(/^I re-submit a valid email$/) do
  taxpayer_details_page.resubmit_valid_email
end

When(/^I submit a taxpayers details form with no phone number$/) do
  expect(taxpayer_details_page.content).to have_header
  taxpayer_details_page.submit_without_taxpayer_phone
end