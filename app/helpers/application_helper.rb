module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    # Support for appending optional css classes, maintaining the default one
    opts.merge!(
      html: { class: dom_class(record, :edit) }
    ) do |_key, old_value, new_value|
      { class: old_value.values | new_value.values }
    end

    form_for(record, opts, &)
  end

  # Render a back link pointing to the user's previous step
  def step_header
    render partial: 'layouts/step_header', locals: {
      path: controller.previous_step_path
    }
  end

  # TODO: fix the rubocop issue
  # rubocop:disable Rails/HelperInstanceVariable
  def govuk_error_summary(form_object = @form_object)
    return if form_object.try(:errors).blank?

    error_messages = form_object.errors.messages.dup
    error_messages.compact_blank!
    token_messsage(form_object) if error_messages.key?(:reset_password_token)
    fields_for(form_object, form_object) do |f|
      f.govuk_error_summary t('errors.error_summary.heading')
    end
  end
  # rubocop:enable Rails/HelperInstanceVariable

  # TODO: if you find the way to display a devise error message for already used token
  # then you can remove this method
  def token_messsage(form_object)
    form_object.errors.clear
    form_object.errors.add(:reset_password_token, 'Reset password token is expired or invalid')
  end

  def translate_for_user_type(key, params={})
    suffix = '_html' if key.end_with?('_html')
    translate_with_appeal_or_application("#{key}.as_#{current_tribunal_case.user_type}#{suffix}", **params)
  end

  def translate_with_appeal_or_application(key, params={})
    translate(key, **params.merge(appeal_or_application_params))
  end

  def escape_govuk_notify(row)
    fields_with_rendering_issues = [:closure_years_under_enquiry]
    if fields_with_rendering_issues.include?(row.question)
      row.value.split('.').join(' .')
    else
      row.value
    end
  end

  def appeal_or_application_params
    appeal_or_application = translate("generic.appeal_or_application.#{current_tribunal_case.appeal_or_application}")

    {
      appeal_or_application:,
      appeal_or_application_capitalised: appeal_or_application.upcase_first
    }
  end

  def analytics_tracking_id
    ENV.fetch('GTM_TRACKING_ID', nil) if Cookie::SettingForm.new(request:).accepted?
  end

  def dynatrace_ui_tracking_id
    Rails.application.config.dynatrace_ui_tracking_id if Cookie::SettingForm.new(request:).accepted?
  end

  def login_or_portfolio_path
    user_signed_in? ? users_cases_path(locale: I18n.locale) : user_session_path(locale: I18n.locale)
  end

  def govuk_help_page_path
    I18n.locale == :en ? 'https://www.gov.uk/help' : 'https://www.gov.uk/cymraeg'
  end

  def service_homepage_url
    Rails.configuration.gds_service_homepage_url
  end

  def title(page_title)
    content_for :page_title, [page_title.presence, t('generic.page_title')].compact.join(' - ')
  end

  # We send a notification to Sentry to be alerted about any missing page titles.
  # If this happens, the title will default to: 'Appeal to the tax tribunal - GOV.UK'
  def fallback_title
    exception = StandardError.new("page title missing: #{controller_name}##{action_name}")
    raise exception if Rails.application.config.consider_all_requests_local
    Sentry.capture_exception(exception)

    title ''
  end

  def multi_answer_i18n_lookup(question, answer)
    t("check_answers.#{question}.answers.#{answer}")
  end

  def address_lookup(record:, entity: , &block)
    show_details = address_lookup_details_filled?(record, entity)

    if address_lookup_access_token
      content_for(:form, &block)
      render(
        partial: 'steps/shared/address_lookup',
        locals: {
          access_token: address_lookup_access_token,
          show_details:
        }
      )
    else
      yield block
    end
  end

  def address_lookup_access_token
    Rails.cache.read('address_lookup')
  end

  def address_lookup_url
    [Rails.configuration.x.address_lookup.endpoint, "/search/places/v1/postcode"].join
  end

  def address_lookup_details_filled?(record, entity)
    record.send("#{entity}_contact_address").present?
  end

  def form_t239_link
    t('links.form_t239')
  end

  def show_cookie_banner?
    !Cookie::SettingForm.new(request:).preference_set?
  end
end
