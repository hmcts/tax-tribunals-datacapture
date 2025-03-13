# frozen_string_literal: true

class Employees::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   # binding.pry
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

  protected
  # def devise_parameter_sanitizer
  #   # binding.pry
  #   # :a
  #   EmployeeParameterSanitizer.new(Employee, :employee, params)
  #   # params.permit(employee_signin: [:email, :password])
  #   # if resource_class == User
  #   #   User::ParameterSanitizer.new(User, :user, params)
  #   # else
  #   #   super # Use the default one
  #   # end
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   binding.pry
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
