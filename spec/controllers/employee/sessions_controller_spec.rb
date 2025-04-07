require 'rails_helper'

RSpec.describe Employees::SessionsController, type: :controller do
  before {
    @request.env["devise.mapping"] = Devise.mappings[:employee]
  }
  describe 'GET #new' do
    it 'renders the sign-in page' do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:employee) { FactoryBot.create(:employee) }

    context 'with valid credentials' do
      it 'signs in the employee and redirects to the root path' do
        post :create, params: { employee: { email: employee.email, password: employee.password } }
        expect(response).to redirect_to(root_path)
        expect(controller.current_employee).to eq(employee)
      end
    end

    context 'with invalid credentials' do
      it 're-renders the sign-in page with an error' do
        post :create, params: { employee: { email: employee.email, password: 'wrongpassword' } }

        expect(response).to render_template(:new)
        expect(controller.current_employee).to be_nil
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:employee) { FactoryBot.create(:employee) }

    before do
      @request.env["devise.mapping"] = Devise.mappings[:employee]
      sign_in_employee employee
    end

    it 'signs out the employee and redirects to the sign-in page' do
      delete :destroy
      expect(response).to redirect_to(new_employee_session_path)
    end
  end
end