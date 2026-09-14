# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def destroy
    current_employee&.invalidate_all_sessions!
    super
  end

  def after_sign_out_path_for(_resource)
    new_employee_session_path
  end

  protected

  def sign_in(resource_name, employee)
    employee.invalidate_all_sessions!
    super(resource_name, employee, force: true)
  end
end
