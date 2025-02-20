class GlimrApiCallJob < ApplicationJob
  queue_as :glimr_api_calls

  def perform(tribunal_case)
    glimr_case = TaxTribs::GlimrNewCase.new(tribunal_case).call
    case_reference = glimr_case.case_reference

    tribunal_case.update(
      case_reference:
    )

    Sentry.capture_message("DEBUG: Sidekiq job executed")
    # rescue StandardError => e
    #   Rails.logger.info({ caller: self.class.name, method: __callee__, error: e }.to_json)
    #   Sentry.capture_exception(e, extra: { tribunal_case_id: tribunal_case.id })
    # on fail can send email to user saying that their case wasn't successfully sent
  end
end
