module Steps
  class SaveAndReturnController < StepController
    skip_before_action :check_tribunal_case_presence
    skip_before_action :check_tribunal_case_status

    def edit
      @form_object = SaveAndReturn::SaveForm.new
    end

    def update
      case permitted_params
      when 'save_for_later'
        session[:save_for_later] = true
        redirect_to new_user_registration_path
      when 'return_to_saved_appeal'
        session[:return_to_saved_appeal] = true
        redirect_to helpers.login_or_portfolio_path
      when 'continue_with_new_appeal'
        session[:continue_with_new_appeal] = true
        if current_tribunal_case&.intent.eql?(Intent::TAX_APPEAL)
          redirect_to edit_steps_appeal_case_type_path
        elsif current_tribunal_case&.intent.eql?(Intent::CLOSE_ENQUIRY)
          redirect_to edit_steps_closure_case_type_path
        end
      else
        update_and_advance(SaveAndReturn::SaveForm)
      end
    end

    private

    def permitted_params(_form_class = {})
      return {} if params[:save_and_return_save_form].nil? || params[:save_and_return_save_form][:save_or_return].nil?
      params[:save_and_return_save_form][:save_or_return]
    end

    def destination
      session['next_step'] || root_url
    end

    def decision_tree(intent_value)
      case intent_value
      when :tax_appeal
        AppealDecisionTree
      when :close_enquiry
        TaxTribs::ClosureDecisionTree
      end
    end
  end
end
