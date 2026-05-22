class RepresentativeProfessionalPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/details/representative_professional_status"

  section :content, '#main-content' do
    element :representatives_header, 'h1', text: I18n.t('steps.details.representative_professional_status.edit.heading.as_representative')
    element :individuals_header, 'h1', text: I18n.t('steps.details.representative_professional_status.edit.heading.as_taxpayer')
    element :practising_solicitor_option, 'label',
            text: I18n.t('steps.details.representative_professional_status.edit.practising_solicitor_option')
    element :tax_agent_option, 'label',
            text: I18n.t('helpers.label.steps_details_representative_professional_status_form.representative_professional_status_options.tax_agent_html')
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_practising_solicitor
    submit_professional_status(:practising_solicitor_option)
  end

  def submit_tax_agent
    submit_professional_status(:tax_agent_option)
  end

  private

  def submit_professional_status(option)
    return if respond_to?(:consume_browser_session_timeout?, true) && consume_browser_session_timeout?

    retry_transient_inspector_node_error(
      reset_session: false,
      success_condition: -> { left_representative_professional_status_page? }
    ) do
      content.public_send(option).click
      continue_or_save_continue
    end
  end

  def left_representative_professional_status_page?
    path = page.current_path

    path && !path.end_with?('/steps/details/representative_professional_status')
  end
end
