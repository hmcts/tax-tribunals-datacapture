class AdditionalInfoPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/closure/additional_info"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.closure.additional_info.edit.heading')
    element :text_area, '.govuk-textarea'
  end
end
