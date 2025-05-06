Given("I am on the challenge decision page") do
  navigate_to_challenge_decision_page_no_user
end

When("I continue with no option selected") do
  continue_or_save_continue
end

Then("I see the problem error message") do
  expect(challenge_decision_page.content.error).to have_error_heading
end

And("I am still on the challenge decision page") do
  expect(challenge_decision_page.content).to have_appeal_header
end

When("I select yes") do
  submit_yes
end

Then("I am taken to the challenge decision status page") do
  expect(challenge_decision_status_page.content).to have_header
end

When("I select no") do
  RSpec::Mocks.with_temporary_scope do
    stub_uploader
    submit_no
  end
end

Then("I am taken to the must appeal decision status page") do
  expect(page).to have_text 'You must appeal the original decision to HMRC'
end

Then('I will see the original notice text') do
  expect(challenge_decision_page.content).to have_dropdown_text
end

When("I press 'Help with challenging a decision'") do
  challenge_decision_page.help_with_challenging_dropdown
end

When("I see a link 'challenge a tax decision with HM Revenue and Customs' with the correct URL") do
  expect(challenge_decision_page.challenging_decision_HMRC_link).to eq('https://www.gov.uk/tax-appeals')
end

When("I see a link 'options when UK border force seizes your things' with the correct URL") do
  expect(challenge_decision_page.border_force_link).to eq('https://www.gov.uk/customs-seizures/overview')
end

When("I see a link 'challenge a national crime agency' with the correct URL") do
  expect(challenge_decision_page.nca_link).to eq('https://www.gov.uk/tax-tribunal/overview')
end

When("I press continue with no response selected") do
  continue_or_save_continue
end

Then("I will see the error response") do
  expect(challenge_decision_status_page.content.error).to have_error_heading
end

And("I will still be on the decision status page") do
  expect(challenge_decision_status_page.content).to have_header
end

When("I select I have a review conclusion letter") do
  challenge_decision_status_page.submit_review_letter
end

Then("I should be on the dispute type page") do
  expect(dispute_type_page.content).to have_header
end

When(/^I select waiting for more than fourty five days$/) do |_arg|
  challenge_decision_status_page.more_than_fourtyfive
end

When(/^I am appealing to TT directly$/) do
  challenge_decision_status_page.direct
end

When(/^I select I was offered a review$/) do
  challenge_decision_status_page.review
end

When("I select I have been waiting less than fourty five days") do
  challenge_decision_status_page.submit_less_than_fourty_five_days
end

Then("I should be taken to the must wait for challenge decision page") do
  expect(page).to have_text "You must wait before you can appeal"
end

When("I select my appeal to HMRC was late") do
  challenge_decision_status_page.late_appeal
end

Then("I am taken to the are you in time page") do
  expect(in_time_page.content).to have_header
end

When(/^I select I have been waiting for fourty five days or more for a review to finish$/) do
  challenge_decision_status_page.more_than_fourtyfive
end

When(/^I select I am appealing direct to the tribunal before receiving a response from HMRC$/) do
  challenge_decision_status_page.direct
end