class CheckAnswersPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/closure/check_answers"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('dictionary.CYA_CONFIRMATION.check_answers.show.page_title')
    element :application_type_heading, 'h2', text: I18n.t('check_answers.sections.closure_type')
    element :taxpayer_details_heading, 'h2', text: I18n.t('check_answers.sections.taxpayer')
    element :enquiry_details_heading, 'h2', text: I18n.t('check_answers.sections.closure_details')
    element :submit_button, :button, text: I18n.t('check_answers.footer.submit_and_continue')
  end

  def submit_check_answers
    content.submit_button.click
  end

end
