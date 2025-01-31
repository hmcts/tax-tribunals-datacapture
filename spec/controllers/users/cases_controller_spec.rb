require 'rails_helper'

RSpec.describe Users::CasesController, type: :controller do
  let(:user) { User.new }

  describe '#index' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        local_get :index
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when user is logged in' do
      let(:finder_double) { double.as_null_object }

      before do
        sign_in(user)
        expect(user).to receive(:tribunal_cases).and_return(finder_double)
      end

      it 'renders the cases portfolio page' do
        local_get :index
        expect(assigns[:tribunal_cases]).not_to be_nil
        expect(response).to render_template(:index)
      end

      it 'sorts the resulting cases by ascending `created_at`' do
        expect(finder_double).to receive(:order).with(created_at: :asc)
        local_get :index
      end
    end
  end

  describe '#edit' do
    let(:tribunal_cases) { double('tribunal cases') }

    before do
      sign_in(user)
    end

    it 'renders the edit page' do
      expect(user).to receive(:pending_tribunal_cases).and_return(tribunal_cases)
      expect(tribunal_cases).to receive(:find_by).with(id: '124').and_return(double)

      local_get :edit, params: { id: 124 }
      expect(assigns[:tribunal_case]).not_to be_nil
      expect(response).to render_template(:edit)
    end

    context 'when tribunal case does not exist' do
      it 'redirects to the case not found error page' do
        local_get :edit, params: { id: 123 }
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end
  end

  describe '#update' do
    let(:tribunal_cases) { double('tribunal cases') }
    let(:tribunal_case) { instance_double(TribunalCase) }

    before do
      sign_in(user)
    end

    it 'updates the tribunal case' do
      expect(user).to receive(:pending_tribunal_cases).and_return(tribunal_cases)
      expect(tribunal_cases).to receive(:find_by).with(id: '124').and_return(tribunal_case)
      expect(tribunal_case).to receive(:update).with(user_case_reference: 'lolz')

      local_patch :update, params: { id: 124, tribunal_case: { user_case_reference: 'lolz' } }
      expect(response).to redirect_to(users_cases_path)
    end

    context 'when tribunal case does not exist' do
      it 'redirects to the case not found error page' do
        local_patch :update, params: { id: 123 }
        expect(response).to redirect_to(case_not_found_errors_path)
      end
    end
  end

  describe '#destroy' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        local_delete :destroy, params: { id: 'any' }
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when user is logged in' do
      let!(:tribunal_case) { TribunalCase.create }
      let(:scoped_result) { double('result') }

      before do
        sign_in(user)
      end

      context 'when tribunal case does not exist' do
        it 'redirects to the case not found error page' do
          local_delete :destroy, params: {id: '123'}
          expect(response).to redirect_to(case_not_found_errors_path)
        end
      end

      context 'when tribunal case exists' do
        before do
          expect(user).to receive(:pending_tribunal_cases).and_return(scoped_result)
          expect(scoped_result).to receive(:find_by).with(id: tribunal_case.id).and_return(tribunal_case)
        end

        it 'deletes the tribunal case by ID' do
          expect {
            local_delete :destroy, params: {id: tribunal_case.id}
          }.to change { TribunalCase.count }.by(-1)
        end

        it 'redirects to the cases portfolio' do
          local_delete :destroy, params: {id: tribunal_case.id}
          expect(response).to redirect_to(users_cases_path)
        end
      end
    end
  end

  describe '#resume' do
    context 'when user is logged out' do
      it 'redirects to the sign-in page' do
        local_get :resume, params: { id: 'any' }
        expect(response).to redirect_to(user_session_path)
      end
    end

    context 'when user is logged in' do
      let!(:tribunal_case) { TribunalCase.create(intent:, case_type:, closure_case_type:) }

      let(:intent) { nil }
      let(:case_type) { nil }
      let(:closure_case_type) { nil }
      let(:scoped_result) { double('result') }

      before do
        sign_in(user)
      end

      context 'when tribunal case does not exist' do
        it 'redirects to the case not found error page' do
          local_get :resume, params: {id: '123'}
          expect(response).to redirect_to(case_not_found_errors_path)
        end
      end

      context 'when tribunal case exists' do
        before do
          expect(user).to receive(:pending_tribunal_cases).and_return(scoped_result)
          expect(scoped_result).to receive(:find_by).with(id: tribunal_case.id).and_return(tribunal_case)
        end

        it 'assigns the chosen tribunal case to the current session' do
          expect(session[:tribunal_case_id]).to be_nil
          local_get :resume, params: {id: tribunal_case.id}
          expect(session[:tribunal_case_id]).to eq(tribunal_case.id)
        end

        context 'redirects to the corresponding resume page' do
          before do
            local_get :resume, params: {id: tribunal_case.id}
          end

          context 'for an appeal case' do
            let(:intent) { Intent::TAX_APPEAL }

            context 'with `case_type` question answered' do
              let(:case_type) { CaseType.new(:anything) }
              it {expect(response).to redirect_to(resume_steps_details_check_answers_path)}
            end

            context 'with `case_type` question not answered' do
              it {expect(response).to redirect_to(steps_appeal_root_path)}
            end
          end

          context 'for a closure case' do
            let(:intent) { Intent::CLOSE_ENQUIRY }

            context 'with `case_type` question answered' do
              let(:closure_case_type) { CaseType.new(:anything) }
              it { expect(response).to redirect_to(resume_steps_closure_check_answers_path) }
            end

            context 'with `case_type` question not answered' do
              it {expect(response).to redirect_to(steps_closure_root_path)}
            end
          end
        end
      end
    end
  end
end
