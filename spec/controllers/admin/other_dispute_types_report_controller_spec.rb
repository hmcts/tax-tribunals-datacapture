require 'rails_helper'

RSpec.describe Admin::OtherDisputeTypesReportController, type: :controller do
  before do
    allow(ENV).to receive(:fetch).with('ADMIN_USERNAME').and_return('admin')
    allow(ENV).to receive(:fetch).with('ADMIN_PASSWORD').and_return(
      '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
    )
  end

  describe '#index' do
    it_behaves_like 'a password-protected admin controller', :index

    context 'correct credentials' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('admin', 'test')
      end

      it 'retrieves the cases where case type is `other`' do
        expect(TribunalCase).to receive(:with_other_dispute_type).and_return(double.as_null_object)
        local_get :index
      end
    end
  end
end
