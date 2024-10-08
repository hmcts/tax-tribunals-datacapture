class GuidancePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/guidance"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('guidance.heading')
    element :visible_first_question, '#accordion-1-heading-0', visible: true
    element :visible_second_question, '#accordion-1-heading-1', visible: true
    element :visible_first_answer, '#accordion-1-content-0', visible: :all
    element :visible_second_answer, '#accordion-1-content-1', visible: :all
    element :open_all, '#accordion-1 .govuk-accordion__show-all-text'
  end

  def click_a_question
    content.visible_first_question.click
  end

  def click_open_all
    content.open_all.click
  end
end
