class SaveReturnPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/save_and_return"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('steps.save_and_return.edit.page_title')
    element :create_account_checkbox, 'label', text: I18n.t('steps.save_and_return.edit.answers.save_for_later')
    element :continue_new_appeal_checkbox, 'label', text: I18n.t('helpers.label.save_or_return_save_form.save_or_return_options.continue_with_new_appeal')
  end

  def skip_save_and_return
    continue_or_save_continue
  end

  def create_new_account
    content.create_account_checkbox.click
    continue_or_save_continue
  end

  def continue_new_appeal
    content.continue_new_appeal_checkbox.click
    continue
  end
end
