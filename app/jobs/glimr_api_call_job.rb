class GlimrApiCallJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: 3

  def tribunal_case_record(tribunal_case_id)
    TribunalCase.find_by(id: tribunal_case_id)
  end

  def perform(tribunal_case_id)
    tribunal_case = tribunal_case_record(tribunal_case_id)
    glimr_case = TaxTribs::GlimrNewCase.new(tribunal_case).call

    case_reference = glimr_case.case_reference

    result = tribunal_case.update(
      case_reference:
    )

    Sentry.capture_message("GLIMR call updated #{result} for #{tribunal_case_id}.")
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { tribunal_case_id: tribunal_case.id })
    Rails.logger.info({ caller: self.class.name, method: __callee__, error: e }.to_json)
    raise e
  end
end
