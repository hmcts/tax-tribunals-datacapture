class ChallengeDecisionPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/challenge/decision"

  section :content, '#main-content' do
    element :appeal_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_direct')
    element :review_header, 'h1', text: I18n.t('steps.challenge.decision.edit.heading_indirect')
    element :help_with_challenging_a_decision, 'span', text: I18n.t('steps.challenge.decision.edit.help_panel.heading')
    element :sign_out, 'label', text: 'layouts.current_user_menu.logout'
    element :dropdown_text, 'p', text: "The original notice letter will say what you can do when you disagree with a tax decision."
    element :challenge_hmrc_link, 'a', text: 'challenging a tax decision with HM Revenue & Customs (HMRC)'
    element :border_force, 'a', text: 'options when UK Border Force (UKBF) seizes your things'
    element :challenge_NCA, 'a', text: 'how to challenge a National Crime Agency (NCA) decision'
    section :error, '.govuk-error-summary' do
      element :error_heading, '.govuk-error-summary__title', text: I18n.t('errors.error_summary.heading')
    end
  end

  def help_with_challenging_dropdown
    content.help_with_challenging_a_decision.click
  end

  def challenging_decision_HMRC_link
    content.challenge_hmrc_link.native.attribute('href')
  end

  def nca_link
    content.challenge_NCA.native.attribute('href')
  end

  def border_force_link
    content.border_force.native.attribute('href')
  end

  def logout
    content.sign_out.click
  end
end
