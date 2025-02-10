require 'rails_helper'

RSpec.describe Steps::Details::UserTypeController, type: :controller do
  it_behaves_like 'a starting point step controller', intent: Intent::CLOSE_ENQUIRY
  it_behaves_like 'an intermediate step controller', Steps::Details::UserTypeForm, DetailsDecisionTree
end
