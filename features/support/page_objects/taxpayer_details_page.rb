class TaxpayerDetailsPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/details/taxpayer_details"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.taxpayer_details.edit.heading')
    element :email_error, 'a', text: I18n.t('activerecord.errors.models.user.attributes.email.blank')
    element :manual_address_link, 'a', text: I18n.t('helpers.address_lookup.enter_address_manually')
    element :first_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_first_name]']"
    element :last_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_last_name]']"
    element :address_input, "textarea[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_address]']"
    element :city_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_city]']"
    element :postcode_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_postcode]']"
    element :country_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_country]']"
    element :email_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_email]']"
    element :phone_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_phone]']"
    sections :input_field, '.govuk-form-group' do
      element :input_label, '.govuk-label'
      element :first_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_first_name]']"
      element :last_name_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_individual_last_name]']"
      element :address_input, "textarea[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_address]']"
      element :city_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_city]']"
      element :postcode_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_postcode]']"
      element :country_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_country]']"
      element :email_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_email]']"
      element :phone_input, "input[name='steps_details_taxpayer_individual_details_form[taxpayer_contact_phone]']"
      element :input_error, '.govuk-error-message'
    end
  end

  def show_manual_address_fields
    return content.address_input if content.has_address_input?(visible: true, wait: 0)

    content.manual_address_link.click
    content.address_input
  end

  def submit_taxpayer_details
    show_manual_address_fields
    content.first_name_input.set 'John'
    content.last_name_input.set 'Smith'
    content.address_input.set '102 Petty France'
    content.city_input.set 'London'
    content.postcode_input.set 'SW1H 9AJ'
    content.country_input.set 'UK'
    content.email_input.set 'matching@email.com'
    content.phone_input.set '07777 888888'

    continue_or_save_continue
  end

  def submit_some_taxpayer_details
    show_manual_address_fields
    content.first_name_input.set 'John'
    content.last_name_input.set 'Smith'
    content.address_input.set '102 Petty France'
    content.city_input.set 'London'
    content.postcode_input.set 'SW1H 9AJ'
    content.country_input.set 'UK'
    content.email_input.set 'matching@email'
    content.phone_input.set '07777 888888'

    continue_or_save_continue
  end

  def resubmit_valid_email
    content.email_input.set 'matching@email.com'

    continue_or_save_continue
  end

  def submit_without_taxpayer_phone
    show_manual_address_fields
    content.first_name_input.set 'John'
    content.last_name_input.set 'Smith'
    content.address_input.set '102 Petty France'
    content.city_input.set 'London'
    content.postcode_input.set 'SW1H 9AJ'
    content.country_input.set 'UK'
    content.email_input.set 'matching@email.com'

    continue_or_save_continue
  end
end
