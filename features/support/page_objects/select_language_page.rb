class SelectLanguagePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/select_language"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.select_language_question')
    element :english_checkbox, 'label', text: I18n.t('dictionary.SUPPORTED_LANGUAGES.english')
    element :welsh_checkbox, 'label', text: I18n.t('dictionary.SUPPORTED_LANGUAGES.welsh')
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def skip_save_and_return
    continue_or_save_continue
  end

  def select_english
    content.english_checkbox.click
    continue
  end
end
