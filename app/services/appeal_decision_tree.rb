class AppealDecisionTree < TaxTribs::DecisionTree
  def destination
    return next_step if next_step

    case step_name.to_sym
    when :save_and_return
      case_type_or_save_step
    when :case_type
      after_case_type_step
    when :case_type_details, :language
      after_case_type_details_step
    when :dispute_type
      after_dispute_type_step
    when :penalty_amount, :penalty_and_tax_amounts, :tax_amount
      hardship_or_lateness_step
    else
      raise "Invalid step '#{step_params}'"
    end
  end

  private

  def after_case_type_step
    if tribunal_case.case_type_other_value
      after_case_type_details_step
    elsif tribunal_case.case_type
      edit('/steps/appeal/case_type_details')
    end
  end

  def after_case_type_details_step
    if tribunal_case.language.blank?
      select_language_path
    elsif tribunal_case.case_type == CaseType::TAX_CREDITS
      show('/steps/appeal/tax_credits_kickout')
    elsif tribunal_case.case_type&.ask_challenged?
      edit('/steps/challenge/decision')
    else
      dispute_or_penalties_decision
    end
  end

  def after_dispute_type_step
    if tribunal_case.dispute_type.ask_penalty?
      edit(:penalty_amount)
    elsif tribunal_case.dispute_type.ask_tax?
      edit(:tax_amount)
    elsif tribunal_case.dispute_type.ask_penalty_and_tax?
      edit(:penalty_and_tax_amounts)
    else
      hardship_or_lateness_step
    end
  end

  def hardship_or_lateness_step
    if tribunal_case.case_type.ask_hardship? && tribunal_case.dispute_type.ask_hardship?
      edit('/steps/hardship/disputed_tax_paid')
    else
      edit('steps/lateness/in_time')
    end
  end

  def case_type_or_save_step
    if tribunal_case.user_id.blank?
      @next_step = case_type_path
      save_return_path
    else
      after_case_type_step
    end
  end
end
