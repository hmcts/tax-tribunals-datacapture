class GlimrApiCallJob < ApplicationJob
  queue_as :glimr_api_calls
  sidekiq_options retry: 3

  def perform(tribunal_case)
    glimr_case = TaxTribs::GlimrNewCase.new(tribunal_case).call
    case_reference = glimr_case.case_reference

    tribunal_case.update(
      case_reference:,
      submitted_at: Time.zone.now,
      case_status: CaseStatus::SUBMITTED
    )

    Sentry.capture_message("DEBUG: Sidekiq job executed")
  end
end