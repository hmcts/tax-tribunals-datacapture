Given("I create an account in appeal journey") do
  save_and_come_back
  expect(save_appeal_page.content).to have_appeal_header
  save_appeal_page.content.email_input.set 'test_tt@hmcts.net'
  save_appeal_page.content.password_input.set 'TaxTribun4!'
  save
  save_confirmation_page.continue
end

Given("I create an account in closure journey") do
  save_and_come_back
  expect(save_appeal_page.content).to have_appeal_header
  save_appeal_page.content.email_input.set 'test_tt@hmcts.net'
  save_appeal_page.content.password_input.set 'TaxTribun4!'
  save
  save_confirmation_page.continue
end

When("I click on continue when I am on the save confirmation page") do
  expect(save_confirmation_page.content).to have_header
  save_confirmation_page.content.continue_button.click
end

Then("I should be on the closure user type page") do
  expect(user_type_page.content).to have_closure_header
end

Given("I am on the closure case type page without login") do
  navigate_to_save_return_page_closure
  save_return_page.continue_new_appeal
end
