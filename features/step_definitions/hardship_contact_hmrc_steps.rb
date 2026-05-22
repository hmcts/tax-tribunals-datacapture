Given("I am on the contact HMRC page") do
  go_to_contact_hmrc_page
  expect(contact_hmrc_page.content).to have_header
end

Given("I select the button to contact HMRC") do
  contact_hmrc_page.redirect_to_contact_hmrc
end

Then("I have a back button") do
  expect(page).to have_link(I18n.t("generic.back_link"))
end

Given('I have the button to contact HMRC') do
  expect(contact_hmrc_page.content).to have_contact_hmrc_button
end

Then('the button is link to a form') do
  expect(contact_hmrc_page.content).to have_form_field
  form_path = contact_hmrc_page.content.form_field.native.attribute('action')
  expect(form_path).to include('steps/hardship/hardship_contact_hmrc')
end

