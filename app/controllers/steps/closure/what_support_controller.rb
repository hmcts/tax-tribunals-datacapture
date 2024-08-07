module Steps::Closure
  class WhatSupportController < Steps::ClosureStepController
    def edit
      @form_object = Steps::Shared::WhatSupportForm.new(
        tribunal_case: current_tribunal_case,
        language_interpreter: current_tribunal_case.language_interpreter,
        language_interpreter_details: current_tribunal_case.language_interpreter_details,
        sign_language_interpreter: current_tribunal_case.sign_language_interpreter,
        sign_language_interpreter_details: current_tribunal_case.sign_language_interpreter_details,
        hearing_loop: current_tribunal_case.hearing_loop,
        disabled_access: current_tribunal_case.disabled_access,
        other_support: current_tribunal_case.other_support,
        other_support_details: current_tribunal_case.other_support_details
      )
      render template: 'steps/shared/what_support/edit'
    end

    def update
      update_and_advance(Steps::Shared::WhatSupportForm, as: :what_support,
        render: 'steps/shared/what_support/edit')
    end
  end
end
