require 'rails_helper'

RSpec.describe Admin::UploadProblemsReportController, type: :controller do
  describe '#index' do
    it_behaves_like 'a password-protected admin controller', :index

    context 'correct credentials' do
      before do
        sign_in double('employee')
      end

      it 'retrieves the cases with document upload problems' do
        expect(TribunalCase).to receive(:with_upload_problems).and_return(double.as_null_object)
        local_get :index
      end
    end
  end
end
