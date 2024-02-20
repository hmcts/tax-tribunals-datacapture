class Admin::AuthenticationFailureHandler < Devise::FailureApp
  protected

  def redirect_url
    new_user_session_path(locale: I18n.locale)
  end
end