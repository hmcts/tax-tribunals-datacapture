class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin

  private

  def check_admin
    return if current_user.admin?

    sign_out(current_user)
    flash[:alert] = "You are not authorized to view this page."
    redirect_to(new_user_session_path(locale: I18n.locale))
  end
end
