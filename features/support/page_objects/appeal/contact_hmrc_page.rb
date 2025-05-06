class ContactHmrcPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/hardship/hardship_contact_hmrc"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.hardship_contact_hmrc.edit.heading')
    element :contact_hmrc_button, 'button', text: I18n.t('steps.hardship.hardship_contact_hmrc.edit.contact_hmrc')
    element :form_field, 'form.button_to'
  end

  def redirect_to_contact_hmrc
    content.contact_hmrc_button.click
  end
end
