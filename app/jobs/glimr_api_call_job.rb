class GlimrApiCallJob < ApplicationJob
  sidekiq_options queue: :glimr_api_calls, retry: 3

  def perform(tribunal_case)
    glimr_case = GlimrNewCase.new(tribunal_case).call
    case_reference = glimr_case.case_reference

    # case_reference could be nil, if GLiMR call failed, but despite this,
    # we want to mark the tribunal case as `submitted`
    tribunal_case.update(
      case_reference:,
      submitted_at: Time.zone.now,
      case_status: CaseStatus::SUBMITTED
    )
  end

end