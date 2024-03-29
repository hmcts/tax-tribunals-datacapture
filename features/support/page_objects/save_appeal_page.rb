class SaveAppealPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/users/sign_up"

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: I18n.t('users.registrations.new.heading_test_fixed_as_appeal')
    element :closure_header, 'h1', text: I18n.t('users.registrations.new.heading_test_fixed_as_application')
    elements :login_label, '.govuk-label'
    element :email_input, '#user-email-field'
    element :password_input, '#user-password-field'
    element :error_message, '.govuk-error-message'
  end
end
