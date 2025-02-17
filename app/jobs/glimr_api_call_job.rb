class GlimrApiCallJob < ApplicationJob
  sidekiq_options queue: :glimr_api_calls, retry: 3

  def perform(tribunal_case)
    glimr_case = GlimrNewCase.new(tribunal_case).call
    case_reference = glimr_case.case_reference

    tribunal_case.update(
      case_reference:,
      submitted_at: Time.zone.now,
      case_status: CaseStatus::SUBMITTED
    )

    Sentry.capture_message("DEBUG: Sidekiq job executed")
  rescue StandardError => e
    Sentry.capture_exception(e, extra: { tribunal_case_id: tribunal_case.id })
    raise e
  end
end