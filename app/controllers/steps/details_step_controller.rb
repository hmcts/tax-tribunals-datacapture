class Steps::DetailsStepController < StepController
  private

  def decision_tree_class
    DetailsDecisionTree
  end

  def intent
    Intent::CLOSE_ENQUIRY
  end
end
