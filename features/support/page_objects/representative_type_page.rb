class RepresentativeTypePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/details/representative_type"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.fieldset.steps_details_representative_type_form.representative_type_html')
    element :individual, 'label', text: I18n.t('steps.details.representative_type.edit.individual')
    element :company, 'label', text: I18n.t('steps.details.representative_type.edit.company')
    element :other, 'label', text: I18n.t('steps.details.representative_type.edit.other')
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_individual
    submit_type(:individual)
  end

  def submit_company
    submit_type(:company)
  end

  def submit_other
    submit_type(:other)
  end

  private

  def submit_type(type)
    return if respond_to?(:consume_browser_session_timeout?, true) && consume_browser_session_timeout?

    retry_transient_inspector_node_error(
      reset_session: false,
      success_condition: -> { left_representative_type_page? }
    ) do
      content.public_send(type).click
      continue_or_save_continue
    end
  end

  def left_representative_type_page?
    page.has_no_css?('h1', text: I18n.t('helpers.fieldset.steps_details_representative_type_form.representative_type_html'), wait: 5)
  end
end
