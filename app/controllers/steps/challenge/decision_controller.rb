module Steps::Challenge
  class DecisionController < Steps::ChallengeStepController
    # steps/challenge/decision is the first step where appeal should be saved
    include StartingPointStep

    def edit
      @form_object = DecisionForm.new(
        tribunal_case: current_tribunal_case,
        challenged_decision: current_tribunal_case.challenged_decision
      )
    end

    def update
      update_and_advance(DecisionForm)
    end

    private

    def intent
      Intent::TAX_APPEAL
    end
  end
end
