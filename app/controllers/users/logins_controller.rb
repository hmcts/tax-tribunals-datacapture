module Users
  class LoginsController < Devise::SessionsController
    def create
      self.resource = warden.authenticate(auth_options)
      if self.resource.blank?
        self.resource = User.signin_errors(params.require(:user).permit(:email, :password))
        render :new
      else
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end

    def save_confirmation
      @email_address = session[:confirmation_email_address]
    end

    def logged_out
    end

    def destroy
      current_user.invalidate_all_sessions!
      super
    end

    def restart_account_creation
      current_user&.invalidate_all_sessions!
      redirect_to new_user_registration_path
    end

    protected

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity:
    def sign_in(_resource_name, user)
      super
      save_for_later = TaxTribs::SaveCaseForLater.new(current_tribunal_case, user)
      if current_tribunal_case&.intent.eql?(Intent::TAX_APPEAL)
        save_for_later.save if current_tribunal_case.respond_to?(:case_type?) && current_tribunal_case.case_type?
      elsif current_tribunal_case&.intent.eql?(Intent::CLOSE_ENQUIRY)
        save_for_later.save if current_tribunal_case.respond_to?(:closure_case_type?) && current_tribunal_case.closure_case_type?
      end
      session[:confirmation_email_address] = user.email if save_for_later.email_sent?
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity:

    # Devise will try to return to a previously login-protected page if available,
    # otherwise this is the fallback route to redirect the user after login
    def signed_in_root_path(_)
      users_cases_path
    end

    def after_sign_out_path_for(_)
      users_login_logged_out_path
    end
  end
end
