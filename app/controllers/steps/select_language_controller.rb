module Steps
  class SelectLanguageController < StepController
    skip_before_action :check_tribunal_case_presence
    skip_before_action :check_tribunal_case_status

    def edit
      redirect_to invalid_session_errors_path unless current_tribunal_case

      @form_object = SelectLanguage::SaveLanguageForm.new(
        tribunal_case: current_tribunal_case,
        language: current_tribunal_case.language
      )
    end

    def update
      redirect_to invalid_session_errors_path unless current_tribunal_case
      update_and_advance(SelectLanguage::SaveLanguageForm)
    end

    private

    def decision_tree_class
      if current_tribunal_case&.tax_appeal?
        AppealDecisionTree
      else
        TaxTribs::ClosureDecisionTree
      end
    end
  end
end
