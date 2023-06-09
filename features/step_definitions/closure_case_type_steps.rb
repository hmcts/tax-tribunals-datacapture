Given("I am on the closure case type page") do
  navigate_to_closure_case_type_page
end

Then("I should see that I can only close one of the listed options") do
  expect(closure_case_type_page.content).to have_one_on_list
end

When("I submit that it is a personal return") do
  closure_case_type_page.submit_personal_return
end

When("I press continue with nothing selected") do
  continue_or_save_continue
end

Then("The error should appear") do
  expect(closure_case_type_page.content).to have_content("There is a problem")
end
