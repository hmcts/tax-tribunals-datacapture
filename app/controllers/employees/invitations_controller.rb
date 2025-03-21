class Employees::InvitationsController < Devise::InvitationsController
  before_action :authenticate_employee!
  before_action :only_admin, only: %i[new]
  before_action :configure_permitted_parameters

  def invite_resource
    super.tap do |employee|
      if params[:employee][:full_name].blank?
        employee.full_name = params[:employee][:email]
        employee.save
      end
    end
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:full_name, :role])
  end

  def after_invite_path_for(_inviter, _invitee = nil)
    employees_accounts_path
  end

  def after_accept_path_for(employee)
    employees_account_path(employee)
  end

  def only_admin
    return if current_employee&.admin?
    flash[:notice] = 'You are not authorized to access this page.'

    redirect_to employees_account_path(current_employee)
  end
end