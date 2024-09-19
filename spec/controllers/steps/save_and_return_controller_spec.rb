require 'rails_helper'

RSpec.describe Steps::SaveAndReturnController do

  describe 'edit' do
    let!(:existing_case) { TribunalCase.create }
    before { local_get :edit, session: { tribunal_case_id: existing_case.id } }

    it { expect(response).to be_successful }
    it { expect(assigns(:form_object)).to be_a_kind_of(SaveAndReturn::SaveForm) }
  end

  describe 'update' do
    let!(:existing_case) { TribunalCase.create(intent: Intent::TAX_APPEAL) }

    context 'return to saved appeal' do
      let(:params) { { save_and_return_save_form: { save_or_return: 'return_to_saved_appeal' } } }
      subject { local_put :update, session: { tribunal_case_id: existing_case.id }, params: }

      before do
        allow_any_instance_of(ApplicationHelper).to receive(:login_or_portfolio_path).and_return(users_cases_path)
      end

      it { expect(subject).to redirect_to(users_cases_path) }
    end

    context 'continue with new appeal' do
      let(:params) { { save_and_return_save_form: { save_or_return: 'continue_with_new_appeal' } } }
      subject { local_put :update, session: { tribunal_case_id: existing_case.id }, params: }

      it { expect(subject).to redirect_to(edit_steps_appeal_case_type_path) }
    end

    context 'go to save for later form' do
      let(:params) { { save_and_return_save_form: { save_or_return: 'save_for_later' }}}
      subject { local_put :update, session: { tribunal_case_id: existing_case.id }, params: }

      it { expect(subject).to redirect_to(new_user_registration_path) }
    end
  end

  describe 'update closure' do
    let!(:existing_case) { TribunalCase.create(intent: Intent::CLOSE_ENQUIRY) }

    context 'continue with new appeal' do
      let(:params) { { save_and_return_save_form: { save_or_return: 'continue_with_new_appeal' } } }
      subject { local_put :update, session: { tribunal_case_id: existing_case.id }, params: }

      it { expect(subject).to redirect_to(edit_steps_closure_case_type_path) }
    end
  end
end
