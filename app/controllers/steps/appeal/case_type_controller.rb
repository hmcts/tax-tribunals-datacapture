module Steps::Appeal
  class CaseTypeController < Steps::AppealStepController
    def edit
      @form_object = CaseTypeForm.new(
        tribunal_case: current_tribunal_case,
        case_type_not_present: current_tribunal_case.case_type_other_value.present?,
        case_type_other_value: current_tribunal_case.case_type_other_value
      )
    end

    def update
      update_and_advance(CaseTypeForm)
    end
  end
end
