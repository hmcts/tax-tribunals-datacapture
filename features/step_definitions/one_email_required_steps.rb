When("I successfully submit representative details with email") do
  representative_details_page.submit_representative_details_with_email
end

When("I successfully submit representative details without email") do
  representative_details_page.submit_representative_details_without_email
end

When("I submit a blank representative details form") do
  expect(representative_details_page.content).to have_header
  continue_or_save_continue
end

Then("I should see a blank email error") do
  expect(taxpayer_details_page.content).to have_email_error
end

Then("I should not see an email error") do
  expect(taxpayer_details_page.content).not_to have_email_error
end

Given("I submit that the representative is a practising solicitor") do
  representative_professional_page.submit_practising_solicitor
end

When("I submit that I have a representative") do
  expect(has_representative_page.content).to have_header
  submit_yes
end

When("I submit that the representative is an individual") do
  expect(representative_type_page.content).to have_header
  representative_type_page.submit_individual
end

When("I submit that I don't want a copy of the case details emailed to the taxpayer") do
  expect(send_taxpayer_copy_page.content).to have_header
  submit_none
end

When("I submit that I don't want a copy of the case details emailed to the representative") do
  expect(send_representative_copy_page.content).to have_header
  submit_none
end

And(/^I submit that the representative is a tax agent$/) do
  representative_professional_page.submit_tax_agent
end

Then(/^I should see 'Do you want to start receiving correspondence from the tribunal\?'$/) do
  expect(page).to have_text('Do you want to start receiving correspondence from the tribunal')
end