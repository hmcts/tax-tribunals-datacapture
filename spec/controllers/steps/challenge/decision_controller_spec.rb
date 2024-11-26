require 'rails_helper'

RSpec.describe Steps::Challenge::DecisionController, type: :controller do
  it_behaves_like 'a starting point step controller', intent: Intent::TAX_APPEAL
  it_behaves_like 'an intermediate step controller', Steps::Challenge::DecisionForm, ChallengeDecisionTree
end
