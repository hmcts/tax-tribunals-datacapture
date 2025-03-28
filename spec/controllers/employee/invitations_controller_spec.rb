require 'rails_helper'

RSpec.describe Employees::InvitationsController, type: :controller do
  let(:employee) { create(:employee, role: 'user', last_sign_in_at: 2.weeks.ago) }
  let(:admin) { create(:employee, role: 'admin', last_sign_in_at: 2.weeks.ago) }
  let(:employee_params) { { full_name: 'John Doe', role: 'user', email: 'john.doe@example.com' } }

  context 'admin' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:employee]
      sign_in_employee employee
    end

    describe 'GET #new' do
      it 'renders the new template' do
        get :new
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
        expect(response).to redirect_to(employees_account_path(employee))
      end
    end
  end

  context 'admin' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:employee]
      sign_in_employee admin
    end

    describe 'GET #new' do
      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end


    describe 'POST #create' do
      context 'with valid parameters' do
        it 'invites a new employee' do
          expect {
            post :create, params: { employee: employee_params }
          }.to change(Employee, :count).by(1)
        end

        it 'redirects to employees accounts path' do
          post :create, params: { employee: employee_params }
          expect(response).to redirect_to(employees_accounts_path)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new employee' do
          expect {
            post :create, params: { employee: { email: '' } }
          }.not_to change(Employee, :count)
        end

        it 'renders the new template' do
          post :create, params: { employee: { email: '' } }
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'before_action filters' do
      it 'calls configure_permitted_parameters before action' do
        expect(controller).to receive(:configure_permitted_parameters)
        post :create, params: { employee: employee_params }
      end
    end
  end
end