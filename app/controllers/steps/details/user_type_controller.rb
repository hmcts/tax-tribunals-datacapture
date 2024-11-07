module Steps::Details
  class UserTypeController < Steps::DetailsStepController
    # steps/details/user_type is the first step where closure should be saved
    include StartingPointStep

    def edit
      @form_object = UserTypeForm.new(
        tribunal_case: current_tribunal_case,
        user_type: current_tribunal_case.user_type
      )
    end

    def update
      update_and_advance(UserTypeForm)
    end

    private

    def intent
      Intent::CLOSE_ENQUIRY
    end
  end
end
