class AppealCaseTypeDetailsPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/appeal/case_type_details"

  section :content, '#main-content' do
    element :title, 'title', text: I18n.t('steps.appeal.case_type_details.edit.page_title')
    element :vat, 'h1', text: I18n.t('helpers.label.steps_appeal_case_type_form.case_type_options.vat')
    element :income_tax, 'h1', text: I18n.t('helpers.label.steps_appeal_case_type_form.case_type_options.income_tax')
    element :student_loans, 'h1', text: I18n.t('helpers.label.steps_appeal_case_type_form.case_type_options.student_loans')
    element :general_hint_text, 'p', text: I18n.t('steps.appeal.case_type_details.edit.general_description_text')
    element :income_tax_hint_text, 'p', text: I18n.t('steps.appeal.case_type_details.edit.income_tax_description_text')
    element :tax_credits_hint_text, 'p', text: I18n.t('steps.appeal.case_type_details.edit.tax_credits_description_text')
  end
end
