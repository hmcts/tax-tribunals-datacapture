Given("I submit that I am an individual") do
  current_type_page.submit_individual
end

Given("I submit that I am a company") do
  current_type_page.submit_company
end

Given("I submit that I am an other") do
  current_type_page.submit_other
end

Given("I click the back button") do
  back
end

When("I click on save and come back later") do
  save_and_come_back
end

When("I click the continue button") do
  continue_or_save_continue
end

Given('I select english only') do
  select_language_page.select_english
end

def current_type_page
  representative_type_heading = I18n.t('helpers.fieldset.steps_details_representative_type_form.representative_type_html')

  return representative_type_page if page.has_css?('h1', text: representative_type_heading, wait: 0)

  taxpayer_type_page
end
