class DisputeTypePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/appeal/dispute_type"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.appeal.dispute_type.edit.heading')
    element :penalty_or_surcharge_option, 'label', text: I18n.t('check_answers.dispute_type.answers.penalty')
    element :repay_option, 'label', text: I18n.t('helpers.label.steps_appeal_dispute_type_form.amount_of_tax_owed_by_hmrc')
    element :owe_option, 'label', text: I18n.t('check_answers.dispute_type.answers.amount_of_tax_owed_by_taxpayer')
    element :owe_and_penalty_option, 'label', text: I18n.t('check_answers.dispute_type.answers.amount_and_penalty')
    element :notice_of_requirement_option, 'label', text: I18n.t('check_answers.dispute_type.answers.security_notice')
    element :registration_option, 'label', text: I18n.t('check_answers.dispute_type.answers.registration')
    element :paye_option, 'label', text: I18n.t('.check_answers.dispute_type.answers.paye_coding_notice')
    element :nota_option, 'label',
            text: I18n.t('helpers.label.steps_details_representative_professional_status_form.representative_professional_status_options.other_html')
    element :nota_option_textbox, "input[name='steps_appeal_dispute_type_form[dispute_type_other_value]']"
    element :enter_answer_error, 'a', text: I18n.t('errors.messages.blank')
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def submit_penalty_or_surcharge
    content.penalty_or_surcharge_option.click
    continue_or_save_continue
  end

  def submit_repay_option
    content.repay_option.click
    continue_or_save_continue
  end

  def submit_owe_option
    content.owe_option.click
    continue_or_save_continue
  end

  def submit_owe_and_penalty_option
    content.owe_and_penalty_option.click
    continue_or_save_continue
  end

  def submit_notice_of_requirement_option
    content.notice_of_requirement_option.click
    continue_or_save_continue
  end

  def submit_registration_option
    content.registration_option.click
    continue_or_save_continue
  end

  def submit_paye_option
    content.paye_option.click
    continue_or_save_continue
  end

  def submit_invalid_nota_option
    content.nota_option.click
    continue_or_save_continue
  end

  def submit_valid_nota_option
    content.nota_option_textbox.set 'Thing'
    content.nota_option.click
    continue_or_save_continue
  end
end
