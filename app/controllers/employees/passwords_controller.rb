# frozen_string_literal: true

class Employees::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    if reset_params['email'].blank?
      flash[:notice] = 'Email cannot be blank'
      @employee = Employee.new
      render :new
    else
      super
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(_resource_name)
    new_employee_session_path
  end

  def reset_params
    params.expect(employee: [:email]).to_h
  end
end
