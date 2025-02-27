module Steps::Appeal
  class CaseTypeDetailsController < Steps::AppealStepController
    def edit
      @tribunal_case = current_tribunal_case
    end

    def update
      if current_tribunal_case.language.blank?
        redirect_to "/#{locale}/steps/select_language", action: :edit
      elsif current_tribunal_case.case_type == CaseType::TAX_CREDITS
        show("/#{locale}/steps/appeal/tax_credits_kickout")
      elsif current_tribunal_case.case_type.ask_challenged?
        redirect_to "/#{locale}/steps/challenge/decision", action: :edit
      elsif tribunal_case.case_type.ask_dispute_type?
        redirect_to "/#{locale}/steps/appeal/dispute_type", action: :edit
      elsif tribunal_case.case_type.ask_penalty?
        redirect_to "/#{locale}/steps/appeal/penalty_amount", action: :edit
      else
        redirect_to "/#{locale}/steps/lateness/in_time", action: :edit
      end
    end
  end
end

