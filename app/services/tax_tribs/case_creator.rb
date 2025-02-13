module TaxTribs
  class CaseCreator
    attr_reader :tribunal_case

    def initialize(tribunal_case)
      @tribunal_case = tribunal_case
    end

    def call

      Sentry.capture_message("INFO: Submitting application in progress")

      tribunal_case.update(
        case_status: CaseStatus::SUBMIT_IN_PROGRESS
      )

      Sentry.capture_message("INFO: Before GLiMR")

      glimr_case = GlimrNewCase.new(tribunal_case).call
      case_reference = glimr_case.case_reference

      Sentry.capture_message("INFO: After GLiMR")

      # case_reference could be nil, if GLiMR call failed, but despite this,
      # we want to mark the tribunal case as `submitted`
      tribunal_case.update(
        case_reference:,
        submitted_at: Time.zone.now,
        case_status: CaseStatus::SUBMITTED
      )

      Sentry.capture_message("INFO: Submitted")
    end
  end
end
