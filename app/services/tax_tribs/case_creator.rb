module TaxTribs
  class CaseCreator
    attr_reader :tribunal_case

    def initialize(tribunal_case)
      @tribunal_case = tribunal_case
    end

    def call
      tribunal_case.update(
        submitted_at: Time.zone.now,
        case_status: CaseStatus::SUBMITTED
      )

      GlimrApiCallJob.perform_later(tribunal_case)

    rescue StandardError => e
      Sentry.capture_exception(e, extra: { tribunal_case_id: tribunal_case.id })
      raise e
    end
  end
end
