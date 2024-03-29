class InTimePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/lateness/in_time"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.lateness.in_time.edit.heading')
    element :yes_option, 'label', text: I18n.t('helpers.label.steps_lateness_in_time_form.in_time_options.yes')
    element :no_option, 'label', text: I18n.t('helpers.label.steps_lateness_in_time_form.in_time_options.no')
    element :not_sure_option, 'label', text: I18n.t('helpers.label.steps_lateness_in_time_form.in_time_options.unsure')
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_yes
    content.yes_option.click
    continue_or_save_continue
  end

  def submit_no
    content.no_option.click
    continue_or_save_continue
  end

  def submit_not_sure
    content.not_sure_option.click
    continue_or_save_continue
  end
end
