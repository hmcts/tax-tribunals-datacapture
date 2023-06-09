require 'rails_helper'

RSpec.describe Users::RegistrationsController do
  let(:tribunal_case) { double.as_null_object }

  before do
    allow(subject).to receive(:current_tribunal_case).and_return(tribunal_case)
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#new' do
    context 'when there is no tribunal case in the session' do
      let(:tribunal_case) { nil }

      it 'redirects to the invalid session error page' do
        local_get :new
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is a case in the session' do
      it 'responds with HTTP success' do
        local_get :new
        expect(response).to be_successful
      end
    end
  end

  describe '#create' do
    context 'when there is no tribunal case in the session' do
      let(:tribunal_case) { nil }

      it 'redirects to the invalid session error page' do
        local_post :create, params: { doesnt: 'matter' }
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is a case in the session' do
      def do_post
        local_post :create, params: { 'user' => {
            'email' => 'foo@bar.com',
            'password' => 'K#9f@vP(va'
        } }
      end

      context 'when the registration was successful' do
        before do
          expect(TaxTribs::SaveCaseForLater).to receive(:new).with(tribunal_case, an_instance_of(User)).and_return(double.as_null_object)
        end

        it 'creates the user and redirects to the confirmation page' do
          expect { do_post }.to change{ User.count }.by(1)
          expect(response).to redirect_to(users_registration_save_confirmation_path)
        end

        it 'creates the user and redirects to the confirmation page' do
          expect(controller).not_to receive(:sign_in)
          do_post
        end

        context 'save_for_later' do
          it 'keep the user signed in' do
            session[:save_for_later] = true
            expect(controller).to receive(:sign_in)
            do_post
          end
        end
      end

      context 'when the registration was unsuccessful' do
        before do
          expect(TaxTribs::SaveCaseForLater).not_to receive(:new)
        end

        it 'does not create the user and re-renders the page' do
          local_post :create, params: { 'user' => {
              'email' => 'foo@bar.com',
              'password' => 'short'
          } }
          expect(subject).to render_template(:new)
        end
      end
    end
  end

  describe '#save_confirmation' do
    context 'when there is no tribunal case in the session' do
      let(:tribunal_case) { nil }

      it 'redirects to the invalid session error page' do
        local_get :save_confirmation
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is a case in the session' do
      it 'renders the expected page' do
        local_get :save_confirmation
        expect(response).to render_template(:save_confirmation)
      end
    end

    context 'when the registration is from save_for_later' do
      before { session[:save_for_later] = true }

      it 'renders the expected page' do
        local_get :save_confirmation
        expect(response).to render_template(:save_confirmation)
      end

      it 'resets the session after rendering the page' do
        expect(subject).not_to receive(:reset_tribunal_case_session)
        local_get :save_confirmation
      end
    end
  end

  describe '#update_confirmation' do
    it 'renders the expected page' do
      local_get :update_confirmation
      expect(response).to render_template(:update_confirmation)
    end
  end

  describe '#edit' do
    let(:user) { User.new }

    before do
      sign_in(user)
    end

    it 'responds with HTTP success' do
      local_get :edit
      expect(response).to be_successful
    end
  end

  describe '#update' do
    let(:user) { User.new }

    before do
      sign_in(user)
      # Bypass Devise database find() so we don't have to persist the test user
      allow(User.to_adapter).to receive(:get!).and_return(user)
    end

    def do_update
      local_put :update, params: { 'user' => {
          current_password: 'passw0rd',
          password: new_password
      }}
    end

    context 'when the parameters are valid' do
      let(:new_password) { 'passw0rd' }

      before do
        expect(user).to receive(:update_with_password).with(hash_including(password: 'passw0rd')).and_return(true)
      end

      it 'redirects to the update confirmation page' do
        do_update
        expect(response).to redirect_to(users_registration_update_confirmation_path)
      end
    end

    context 'when the parameters are not valid' do
      let(:new_password) { '' }

      before do
        expect(user).to receive(:update_with_password).with(hash_including(password: '*')).and_call_original
      end

      it 'renders to the update page' do
        do_update
        expect(subject).to render_template(:edit)
      end
    end
  end
end
