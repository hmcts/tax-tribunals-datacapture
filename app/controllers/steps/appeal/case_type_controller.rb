module Steps::Appeal
  class CaseTypeController < Steps::AppealStepController
    def edit
      @form_object = CaseTypeForm.new(
        tribunal_case: current_tribunal_case,
        case_type: current_tribunal_case.case_type
      )
    end

    def update
      update_and_advance(CaseTypeForm)
    end
  end
end
