require 'rails_helper'

RSpec.describe Admin::OtherCaseTypesReportController, type: :controller do
  it_behaves_like 'a password-protected admin controller', :index
end
