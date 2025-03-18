class Employees::AccountsController < ApplicationController
  before_action :authenticate_employee!

  def index
    redirect_with_warning unless current_employee&.admin?

    if params_permit.present?
      filter_employess(params_permit['status'])
    else
      @employees = Employee.all
    end
  end

  protected

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
end