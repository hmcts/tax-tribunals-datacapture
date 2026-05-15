class ClosureCaseTypePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/closure/case_type"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('check_answers.closure_case_type.question')
    element :one_on_list, '.govuk-hint'
    element :personal_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.personal_return')
    element :company_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.company_return')
    element :partnership_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.partnership_return')
    element :trustee_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.trustee_return')
    element :enterprise_mgmt_incentives, 'label', text: I18n.t('check_answers.closure_case_type.answers.enterprise_mgmt_incentives')
    element :non_resident_capital_gains_tax, 'label', text: I18n.t('check_answers.closure_case_type.answers.non_resident_capital_gains_tax')
    element :stamp_duty_land_tax_return, 'label', text: I18n.t('check_answers.closure_case_type.answers.stamp_duty_land_tax_return')
    element :transactions_in_securities, 'label', text: I18n.t('check_answers.closure_case_type.answers.transactions_in_securities')
    element :claim_or_amendment, 'label', text: I18n.t('check_answers.closure_case_type.answers.claim_or_amendment')
  end

  def submit_personal_return
    page.execute_script("arguments[0].click();", content.personal_return.native)
    continue_or_save_continue
  end

  def submit_company_return
    page.execute_script("arguments[0].click();", content.company_return.native)
    continue_or_save_continue
  end

  def submit_partnership_return
    page.execute_script("arguments[0].click();", content.partnership_return.native)
    continue_or_save_continue
  end

  def submit_trustee_return
    page.execute_script("arguments[0].click();", content.trustee_return.native)
    continue_or_save_continue
  end

  def submit_enterprise_mgmt_incentives
    page.execute_script("arguments[0].click();", content.enterprise_mgmt_incentives.native)
    continue_or_save_continue
  end

  def submit_non_resident_capital_gains_tax
    page.execute_script("arguments[0].click();", content.non_resident_capital_gains_tax.native)
    continue_or_save_continue
  end

  def submit_stamp_duty_land_tax_return
    page.execute_script("arguments[0].click();", content.stamp_duty_land_tax_return.native)
    continue_or_save_continue
  end

  def submit_transactions_in_securities
    page.execute_script("arguments[0].click();", content.transactions_in_securities.native)
    continue_or_save_continue
  end

  def submit_claim_or_amendment
    page.execute_script("arguments[0].click();", content.claim_or_amendment.native)
    continue_or_save_continue
  end
end
