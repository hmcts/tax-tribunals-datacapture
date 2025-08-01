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
      GlimrApiCallJob.perform_now(tribunal_case.id)
      tribunal_case.reload
    end
  end
end
