require 'rails_helper'

RSpec.describe Employees::AccountsController, type: :controller do
  let(:employee) { FactoryBot.create(:employee) }
  let(:employee2) { FactoryBot.create(:employee) }
  let(:admin) { FactoryBot.create(:employee, role: 'admin', last_sign_in_at: 2.weeks.ago) }

  describe 'GET #index' do
    context 'when the employee is not authenticated' do
      it 'redirects to the login page' do
        get :index
        expect(response).to redirect_to(new_employee_session_path)
      end
    end

    context 'when the employee is authenticated but not an admin' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:employee]
        sign_in_employee employee
      end

      it 'redirects to the root path with a warning' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when the employee is an admin' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:employee]
        sign_in_employee admin
      end

      it 'assigns all employees when no status is provided' do
        employees = FactoryBot.create_list(:employee, 3)
        employees << admin
        get :index
        expect(assigns(:employees)).to match_array(employees)
      end

      it 'filters employees by active status' do
        active_employees =FactoryBot.create_list(:employee, 2, last_sign_in_at: 1.week.ago)
        active_employees << admin
        FactoryBot.create(:employee, last_sign_in_at: 4.months.ago)

        get :index, params: { employee: { status: 'active' } }
        expect(assigns(:employees)).to match_array(active_employees)
        expect(assigns(:status)).to eq('active')
      end

      it 'filters employees by inactive status' do
        inactive_employees = FactoryBot.create_list(:employee, 2, last_sign_in_at: 4.months.ago)
        FactoryBot.create(:employee, last_sign_in_at: 1.week.ago)

        get :index, params: { employee: { status: 'inactive' } }
        expect(assigns(:employees)).to match_array(inactive_employees)
        expect(assigns(:status)).to eq('inactive')
      end

    end
  end

  describe 'GET #edit' do
    context 'when the employee is not authenticated' do
      it 'redirects to the login page' do
        get :edit, params: { id: employee.id }
        expect(response).to redirect_to(new_employee_session_path)
      end
    end

    context 'when the employee is authenticated but not an admin' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:employee]
        sign_in_employee employee2
      end

      it 'redirects to the root path with a warning' do
        get :edit, params: { id: employee.id }
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when the employee edits his account' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:employee]
        sign_in_employee employee
      end

      it 'redirects to the root path with a warning' do
        get :edit, params: { id: employee.id }
        expect(response).to render_template(:edit)
        expect(assigns(:employee)).to eq(employee)
      end
    end

    context 'when the employee is an admin' do
      before do
        @request.env["devise.mapping"] = Devise.mappings[:admin]
        sign_in_employee admin
      end

      it 'assigns the requested employee to @employee' do
        get :edit, params: { id: employee.id }
        expect(assigns(:employee)).to eq(employee)
      end

      it 'renders the edit template' do
        get :edit, params: { id: employee.id }
        expect(response).to render_template(:edit)
      end
    end
  end
end