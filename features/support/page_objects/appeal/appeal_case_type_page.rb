class AppealCaseTypePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/appeal/case_type"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CASE_TYPE_QUESTION.heading')
    element :income_tax, 'label', text: I18n.t('helpers.label.steps_appeal_case_type_form.case_type_options.income_tax')
    element :more_case_types, '#case_type_more'
    element :other_option_checkbox, 'label', text: I18n.t('helpers.label.steps_appeal_case_type_form.case_type_not_present')
    element :other_option_text_input, 'input[name="steps_appeal_case_type_form[case_type_other_value]"]'
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
      element :error_link, 'a', text: I18n.t('activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type.inclusion')
      element :presence_error, 'a', text: I18n.t('activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type_other_value.blank')
    end
  end

  def submit_income_tax
    content.income_tax.click
    continue
  end

  def submit_student_loans
    content.more_case_types.select 'Student loans'
    continue
  end

  def submit_other
    content.other_option_checkbox.click
    continue_or_save_continue
  end

  def submit_other_with_text
    content.other_option_checkbox.click
    content.other_option_text_input.set 'other case type'
    continue_or_save_continue
  end
end
