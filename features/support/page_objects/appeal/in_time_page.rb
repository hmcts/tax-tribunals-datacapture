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
    submit_option(:yes_option)
  end

  def submit_no
    submit_option(:no_option)
  end

  def submit_not_sure
    submit_option(:not_sure_option)
  end

  private

  def submit_option(option)
    return if respond_to?(:consume_browser_session_timeout?, true) && consume_browser_session_timeout?

    content.public_send(option).click
    continue_or_save_continue
  end
end
