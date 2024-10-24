class SaveConfirmationPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/users/registration/save_confirmation"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('users.logins.save_confirmation.heading')
    element :continue_button, '.govuk-button', text: I18n.t('users.shared.case_saved.continue')
  end

  def continue
    content.continue_button.click
  end
end
