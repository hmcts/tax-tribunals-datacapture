class LatenessReasonPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/lateness/lateness_reason"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('helpers.label.steps_lateness_lateness_reason_form.heading')
    element :not_sure_header, 'h1', text: I18n.t('helpers.label.steps_lateness_lateness_reason_form.not_sure_heading')
    element :textarea, '.govuk-textarea'
    element :file_upload_requirements_dropdown, 'span', text: I18n.t('shared.file_upload.header')
    element :file_requirements_dropdown_content, 'p',
            text: "You can’t upload executable (.exe), zip or other archive files due to virus risks."
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def valid_submission
    content.textarea.set 'Reason for lateness'
    continue_or_save_continue
  end

  def file_upload_dropdown
    content.file_upload_requirements_dropdown.click
  end

  def attach_file_to_uploader(filename)
    within(".govuk-drop-zone") do
      find('input[type="file"]', visible: false).attach_file(filename)
    end
  end
end
