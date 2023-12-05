class OutcomePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/details/outcome"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.details.outcome.edit.heading')
    element :textarea, '.govuk-textarea'
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def valid_submission
    content.textarea.set 'Outcome'
    continue_or_save_continue
  end
end
