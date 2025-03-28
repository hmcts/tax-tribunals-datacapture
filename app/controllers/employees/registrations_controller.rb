# frozen_string_literal: true

class Employees::RegistrationsController < Devise::RegistrationsController

  # PUT /resource
  def update
    super do |resource|
      if params[:employee][:password].blank?
        resource.errors.add(:password, I18n.t('devise.passwords.new_password_blank'))
      end
    end
  end

  protected

  def after_update_path_for(_)
    employees_account_path(current_employee)
  end

  # oveeride when there is a resource type error
  def is_flashing_format?
    false if resource.errors.blank?
  end
end
