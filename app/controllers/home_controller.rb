class HomeController < ApplicationController
  def index
    reset_tribunal_case_session
    @link_sections = link_sections
  end

  def contact
  end

  def cookies
    @form_object = Cookie::SettingForm.new(
      request:
    )
  end

  def terms
  end

  def privacy
  end

  def accessibility
  end

  def guidance
  end

  def update
    Cookie::SettingForm.new(
      cookie_setting:,
      response:
    ).save
    flash[:cookie_notification] = cookie_notification
    # TODO: check if there is safer way to do this
    redirect_to request.referer, allow_other_host: true
  end

  private

  def cookie_setting
    params[:cookie_setting_form].
      permit(:cookie_setting).
      to_h.
      fetch(:cookie_setting)
  end

  def cookie_notification
    if params[:cookie_banner].present?
      cookie_setting
    else
      true
    end
  end

  # [task name (used for i18n), estimated minutes to complete this task, path/url to the task]
  # Use '0' minutes to hide the time to complete paragraph
  def link_sections
    [
      [:guidance, 0, guidance_path(locale: I18n.locale)],
      [:appeal, 30, appeal_path(locale: I18n.locale)],
      [:close, 15, closure_path(locale: I18n.locale)],
      [:home_login, 0, helpers.login_or_portfolio_path]
    ]
  end
end
