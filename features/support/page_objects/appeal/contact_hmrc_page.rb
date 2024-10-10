class ContactHmrcPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/hardship/hardship_contact_hmrc"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.hardship.hardship_contact_hmrc.edit.heading')
    element :contact_hmrc, 'button', text: I18n.t('steps.hardship.hardship_contact_hmrc.edit.contact_hmrc')
  end
  def redirect_to_contact_hmrc
    content.contact_hmrc.click
  end
end
