class Employees::AccountsController < AdminController
  # before_action :authenticate_employee!
  before_action :check_edit_permmission, only: %i[edit update]
  before_action :load_employee, only: %i[edit update show destroy]

  def index
    redirect_with_warning unless current_employee&.admin?

    if params_permit.present?
      filter_employess(params_permit['status'])
    else
      @employees = Employee.all
    end
  end

  def show; end
  def edit; end

  def update
    if @employee.update(employee_params)
      flash[:notice] = "Staff account successfully updated."
      redirect_to employees_account_path(@employee)
    else
      flash[:alert] = @employee.errors.full_messages.join(', ')
      render :edit
    end
  end

  def destroy
    if current_employee&.admin? && @employee != current_employee
      if @employee.destroy
        flash[:notice] = "Staff account successfully deleted."
        redirect_to employees_accounts_path
      else
        render :edit
      end
    else
      flash[:notice] = "You are not authorized to delete this account."
      redirect_to root_url
    end
  end

  protected

  def load_employee
    @employee = Employee.find(params[:id])
  end

  def redirect_with_warning
    flash[:notice] = 'You are not authorized to access this page.'
    redirect_to root_path
  end

  def params_permit
    return if params[:employee].nil?
    params.expect(employee: [:status]).to_h
  end

  def filter_employess(status)
    @status = status
    @employees = if status == 'active'
                   Employee.active_list
                 elsif status == 'inactive'
                   Employee.inactive_list
                 else
                   Employee.all
                 end
  end

  def check_edit_permmission
    return if current_employee.present? && (current_employee.id == params[:id] || current_employee&.admin?)
    redirect_with_warning
  end

  def employee_params
    params.expect(employee: [:full_name, :role, :email])
  end
end