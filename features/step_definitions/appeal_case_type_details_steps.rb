Then("I am on the Income Tax case type details page") do
  expect(appeal_case_type_details_page.content).to have_income_tax
  expect(appeal_case_type_details_page.content).to have_income_tax_hint_text
  continue_or_save_continue
end

Then("I am on the vat case type details page") do
  expect(appeal_case_type_details_page.content).to have_vat
  expect(appeal_case_type_details_page.content).to have_vat_hint_text
  continue_or_save_continue
end

Then("I am on the Student loans case type details page") do
  expect(appeal_case_type_details_page.content).to have_student_loans
  expect(appeal_case_type_details_page.content).to have_general_hint_text
  continue_or_save_continue
end