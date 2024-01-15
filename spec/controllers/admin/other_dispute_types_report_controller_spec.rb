require 'rails_helper'

RSpec.describe Admin::OtherDisputeTypesReportController, type: :controller do
  describe '#index' do
    it_behaves_like 'a password-protected admin controller', :index

    context 'correct credentials' do
      let(:user) { FactoryBot.create(:user, admin: true) }
      before do
        sign_in user
      end

      it 'retrieves the cases where case type is `other`' do
        expect(TribunalCase).to receive(:with_other_dispute_type).and_return(double.as_null_object)
        local_get :index
      end
    end
  end
end
