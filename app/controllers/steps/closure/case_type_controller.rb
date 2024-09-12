module Steps::Closure
  class CaseTypeController < Steps::ClosureStepController
    skip_before_action :check_tribunal_case_presence

    def edit
      @form_object = CaseTypeForm.new(
        tribunal_case: current_tribunal_case,
        closure_case_type: current_tribunal_case.closure_case_type
      )
    end

    def update
      update_and_advance(CaseTypeForm, as: :case_type)
    end
  end
end
