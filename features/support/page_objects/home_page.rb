class HomePage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/"

  section :content, '#main-content' do
    element :header, 'h1', text: I18n.t('home.index.heading')
    element :appeal_link, 'a', text: I18n.t('home.index.link_titles.appeal')
    element :close_enquiry_link, 'a', text: I18n.t('home.index.link_titles.close')
    element :return, 'a', text: I18n.t('home.index.link_titles.home_login')
    element :view_guidance_link, 'a', text: I18n.t('home.index.link_titles.guidance')
    element :time_information_tax, 'p', text: '(30 minutes to complete)'
    element :time_information_enquiry, 'p', text: '(15 minutes to complete)'
  end

  section :cookie_banner, '.govuk-cookie-banner' do
    element :header, 'h2', text: I18n.t('cookies.banner.heading')
    element :accept_button, "button", text: "#{I18n.t('cookies.banner.button.accept')}"
    element :reject_button, "button", text: "#{I18n.t('cookies.banner.button.reject')}"
  end


  def appeal
    content.appeal_link.click
  end

  def close_enquiry
    content.close_enquiry_link.click
  end

  def return
    content.return.click
  end

  def view_guidance
    content.view_guidance_link.click
  end
end
