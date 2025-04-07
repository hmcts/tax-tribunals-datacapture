require 'rails_helper'

RSpec.describe Admin::OtherDisputeTypesReportController, type: :controller do
  let(:employee) { double('employees') }

  describe '#index' do
    context 'correct credentials' do
      before do
        sign_in employee
      end

      it 'retrieves the cases where case type is `other`' do
        expect(TribunalCase).to receive(:with_other_dispute_type).and_return(double.as_null_object)
        local_get :index
      end
    end

    context 'not signed in' do
      it 'retrieves the cases where case type is `other`' do
        local_get :index
        expect(response).to redirect_to(new_employee_session_path)
      end
    end
  end
end
