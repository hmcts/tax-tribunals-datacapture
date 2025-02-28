module Users
  class RegistrationsController < Devise::RegistrationsController

    def save_confirmation
      @email_address = current_tribunal_case.user.email if current_user
    end

    def update_confirmation
    end

    protected

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def sign_up(_resource_name, user)
      save_for_later = TaxTribs::SaveCaseForLater.new(current_tribunal_case, user)
      if current_tribunal_case&.intent.eql?(Intent::TAX_APPEAL)
        save_for_later.save if current_tribunal_case.case_type.present?
      elsif current_tribunal_case&.intent.eql?(Intent::CLOSE_ENQUIRY)
        save_for_later.save if current_tribunal_case.closure_case_type.present?
      end
      super if session[:save_for_later] == true || session[:continue_with_new_appeal] == true
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    # Devise will not give an error when leaving blank the new password, it will just ignore the update,
    # which is a very confusing behaviour IMO. Overriding this method to force validation on this field.
    # https://github.com/plataformatec/devise/issues/1955
    def update_resource(resource, params)
      params[:password] = '*' if params[:password].blank?
      super
    end

    def after_sign_up_path_for(_)
      if current_tribunal_case.intent.eql?(Intent::TAX_APPEAL)
        current_tribunal_case.case_type? ? users_registration_save_confirmation_path : edit_steps_appeal_case_type_path
      elsif current_tribunal_case.intent.eql?(Intent::CLOSE_ENQUIRY)
        current_tribunal_case.closure_case_type? ? users_registration_save_confirmation_path : edit_steps_closure_case_type_path
      else
        users_registration_save_confirmation_path
      end
    end

    def after_update_path_for(_)
      users_registration_update_confirmation_path
    end
  end
end
