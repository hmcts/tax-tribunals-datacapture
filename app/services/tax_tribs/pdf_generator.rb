class TaxTribs::PdfGenerator
  STATUS = {
    AppealCaseRebuildsController: {
      ATTEMPT: 'APPEAL_ATTEMPT',
      FAILED: 'APPEAL_FAILED'
    },
    ClosureCaseRebuildsController: {
      ATTEMPT: 'CLOSURE_ATTEMPT',
      FAILED: 'CLOSURE_FAILED'
    },
    AppealCasesController: {
      ATTEMPT: 'APPEAL_ATTEMPT',
      FAILED: 'APPEAL_FAILED'
    },
    ClosureCasesController: {
      ATTEMPT: 'CLOSURE_ATTEMPT',
      FAILED: 'CLOSURE_FAILED'
    }
  }.freeze

  def initialize(tribunal_case, html, controller_name, test_early_exit: false)
    @tribunal_case = tribunal_case
    @controller_name = controller_name.to_sym
    @html = html
    @test_early_exit = test_early_exit
  end

  def generate
    mark_as_attempted
    pdf = WickedPdf.new.pdf_from_string(@html)
    mark_as_succeeded

    pdf
  rescue StandardError => e
    return if @test_early_exit # to simulate Grover crashing server
    mark_as_failed
    Sentry.capture_exception(e)
  end

  private

  def mark_as_attempted
    update_status(STATUS[@controller_name][:ATTEMPT])
  end

  def mark_as_failed
    update_status(STATUS[@controller_name][:FAILED])
  end

  def mark_as_succeeded
    update_status(nil)
  end

  def update_status(status)
    @tribunal_case.update(pdf_generation_status: status)
  end
end