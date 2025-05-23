Given("I have an appeal in progress") do
  home_page.load_page
  home_page.appeal
  appeal_page.continue
  save_return_page.continue_new_appeal
  appeal_case_type_page.submit_income_tax
  continue_or_save_continue
  select_language_page.select_english
  expect(challenge_decision_page.content).to have_appeal_header
end

Then("I am taken to the save your appeal page") do
  expect(save_appeal_page.content).to have_appeal_header
  expect(save_appeal_page).to be_displayed
end

When("I enter a valid email address") do
  expect(save_appeal_page.content.login_label[0].text).to eq I18n.t('helpers.label.user.email')
  save_appeal_page.content.email_input.set Faker::Internet.email
end

When("I enter a password that is not at least 10 characters") do
  expect(save_appeal_page.content.login_label[1].text).to eq I18n.t('helpers.label.user.password')
  save_appeal_page.content.password_input.set 'Pa$0'
  save
end

When("I enter the same password as the email address") do
  save_appeal_page.content.email_input.set    '23lk21j3@alsdnklas.com'
  save_appeal_page.content.password_input.set '23lk21j3@alsdnklas.com'
  save
end

And("I enter a valid password") do
  save_appeal_page.content.password_input.set '$%BjTvZjB0'
  save
end

Then("I should see a password error message") do
  expect(save_appeal_page.content).to have_error_message
end

Then("I should be taken to the saved confirmation page") do
  expect(save_confirmation_page.content).to have_header
end

When("I click 'start again'") do
  click_link(I18n.t('users.shared.case_saved.no_email_invalid_entry_link'))
end

When(/^I enter an invalid email address$/) do
  save_appeal_page.content.email_input.set 'invalid@email'
end

Then(/^I will see an invalid email error message$/) do
  expect(save_appeal_page).to have_text('Please enter an email address in the correct format, like name@example.com')
end

When(/^I click the 'Sign into an existing account' link$/) do
  click_link('Sign into an existing account')
end

Then(/^I should see the sign in page$/) do
  expect(page).to have_title('Sign in - Appeal to the tax tribunal - GOV.UK')
end