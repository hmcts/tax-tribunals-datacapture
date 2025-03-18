RSpec.describe Employees::AccountsController, type: :controller do
  let(:employee) { FactoryBot.create(:employee) }
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
        sign_in employee
      end

      it 'redirects to the root path with a warning' do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('You are not authorized to access this page.')
      end
    end

    context 'when the employee is an admin' do
      before do
        sign_in admin
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
end