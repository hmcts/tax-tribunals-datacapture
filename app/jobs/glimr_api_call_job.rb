class GlimrApiCallJob < ApplicationJob
  queue_as :glimr_api_calls
  sidekiq_options retry: 3

  def perform(tribunal_case)
    Rails.logger.info("DEBUG: BEFORE CALL")

    glimr_case = TaxTribs::GlimrNewCase.new(tribunal_case).call

    Rails.logger.info("DEBUG: AFTER CALL")

    case_reference = glimr_case.case_reference

    tribunal_case.update(
      case_reference:
    )
    Rails.logger.info("DEBUG: AFTER CASE REFERENCE: #{case_reference}")
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { tribunal_case_id: tribunal_case.id })
    Rails.logger.info({ caller: self.class.name, method: __callee__, error: e }.to_json)
    raise e
  end
end
