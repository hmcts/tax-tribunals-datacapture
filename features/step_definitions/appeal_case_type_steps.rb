Given("I am on the appeal case type page") do
  navigate_to_appeal_case_type_page
end

Given("I am on the appeal case type page without login") do
  navigate_to_save_return_page_appeal
  save_return_page.continue_new_appeal
end

When("I click on continue without selecting an option") do
  continue_or_save_continue
end

Then("I should see appeal case type error message") do
  expect(appeal_case_type_page.content.error).to have_error_heading
  expect(appeal_case_type_page.content.error).to have_error_link
end

When("I click on continue after selecting Income Tax option") do
  appeal_case_type_page.submit_income_tax
end

Then("I should be on the appeal challenge decision page") do
  expect(challenge_decision_page.content).to have_appeal_header
end

Then("I should be on the review challenge decision page") do
  expect(challenge_decision_page.content).to have_review_header
end

When("I click on continue after selecting Other option") do
  appeal_case_type_page.submit_other
end

Then("I should be on the language selection page") do
  expect(select_language_page.content).to have_header
end

When("I am on the case type show more page") do
  expect(appeal_case_type_show_more_page.content).to have_header
  expect(appeal_case_type_show_more_page.content).to have_aggregates_levy_option
end

Then("I should be on the appeal case type page") do
  expect(appeal_case_type_page.content).to have_header
  expect(appeal_case_type_page.content).to have_income_tax
end

Then("I should see answer error message") do
  expect(appeal_case_type_show_more_page.content.error).to have_answer_error_heading
  expect(appeal_case_type_show_more_page.content.error).to have_answer_error_link
end

When("I click on None of the above option") do
  appeal_case_type_show_more_page.content.none_of_above_option.click
end

When("I click on continue without providing an answer") do
  continue_or_save_continue
end

When("I click on continue after providing an answer") do
  appeal_case_type_show_more_page.content.none_of_above_answer_box.set 'Reason'
  continue_or_save_continue
  select_language_page.select_english
end

When("I click on continue after selecting Aggregates Levy option") do
  appeal_case_type_show_more_page.submit_aggregates_levy_option
  select_language_page.select_english
end

Then("I should be on the challenge decision page") do
  expect(challenge_decision_page.content).to have_help_with_challenging_a_decision
end

Then("I should be on the lateness page") do
  expect(in_time_page.content).to have_header
end

Then("I should be on the contact HMRC page") do
  expect(contact_hmrc_page.content).to have_header
end

And("I select nothing then english only") do
  continue_or_save_continue
  expect(select_language_page.content.error).to have_error_heading
  select_language_page.select_english
end

And("I choose to select english only") do
  select_language_page.select_english
end

Then(/^I should see a 'Select what your appeal is about' error$/) do
  expect(appeal_case_type_page).to have_text("Select what your appeal is about")
end