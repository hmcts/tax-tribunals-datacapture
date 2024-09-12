require 'rails_helper'

RSpec.describe Users::LoginsController do
  let(:user) { User.new(email: 'foo@bar.com') }
  let(:tribunal_case) { instance_double(TribunalCase, intent: Intent::TAX_APPEAL, user: user, case_type?: true) }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
    allow(warden).to receive(:authenticate).and_return(user)
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    it 'responds with HTTP success' do
      local_get :new
      expect(response).to be_successful
    end
  end

  describe '#create' do
    def do_post
      local_post :create, params: { 'user' => {
        email: 'foo@bar.com',
        password: 'passw0rd'
      }}
    end

    context 'when the authentication was successful' do
      it 'signs the user in and takes to case type page' do
        do_post
        expect(response).to redirect_to(users_cases_path)
      end

      context 'when the case already belongs to the user (we do not send an email)' do
        it 'does not store the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to be_nil
        end
      end

      context 'when the case is new and we are linking it to the user (we send an email)' do
        before do
          expect(TaxTribs::SaveCaseForLater).to receive(:new).with(tribunal_case, user).and_return(double(save: true, email_sent?: true))
        end

        it 'it stores the signed in email address in the session' do
          do_post
          expect(session[:confirmation_email_address]).to eq('foo@bar.com')
        end
      end
    end

    context 'when the authentication was unsuccessful' do
      before do
        expect(warden).to receive(:authenticate).and_call_original
        expect(TaxTribs::SaveCaseForLater).not_to receive(:new)
      end

      it 'does not sign a user in and re-renders the page' do
        do_post
        expect(subject).to render_template(:new)
      end
    end
  end

  describe '#destroy' do
    it 'redirects to the logged out page' do
      local_delete :destroy
      expect(subject).to redirect_to(users_login_logged_out_path)
    end
  end

  describe '#logged_out' do
    it 'renders the expected page' do
      local_get :logged_out
      expect(response).to render_template(:logged_out)
    end
  end

  describe '#save_confirmation' do
    it 'renders the expected page' do
      local_get :save_confirmation
      expect(response).to render_template(:save_confirmation)
    end
  end

  describe '#restart_account_creation' do
    context 'when logged in' do
      let(:user) { User.new(email: 'foo@bar.com') }

      it 'renders the expected page' do
        expect(warden).to receive(:authenticate).and_return(user)
        local_delete :restart_account_creation
        expect(response).to redirect_to new_user_registration_path
      end

      it 'logs the user out' do
        expect(warden).to receive(:authenticate).and_return(user)
        expect(subject.current_user.session_token).to be_nil
        local_delete :restart_account_creation
        expect(subject.current_user.session_token).not_to be_nil
      end
    end

    context 'when not logged in' do
      it 'renders the expected page' do
        local_delete :restart_account_creation
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
end
