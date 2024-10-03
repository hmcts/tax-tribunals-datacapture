class TaxTribs::RebuildPdf
  STATUS = TaxTribs::PdfGenerator::STATUS

  def self.rebuild
    TribunalCase.where.not(pdf_generation_status: nil).find_each do |tc|
      build(tc)
    rescue StandardError => e
      Sentry.capture_message(e.message,
                             extra: { case_reference: tc.case_reference, event: 'rebuild pdf' })
    end
  end

  def self.build(tribunal_case)
    controller_object = controller_for(tribunal_case)
    controller_object.request = ActionDispatch::Request.new({})
    controller_object.current_tribunal_case = tribunal_case
    presenter = controller_object.presenter

    TaxTribs::CaseDetailsPdf.new(tribunal_case, controller_object, presenter).
      generate_and_upload
  end

  def self.controller_for(tribunal_case)
    if tribunal_case.pdf_generation_status.include?('APPEAL')
      AppealCaseRebuildsController.new
    elsif tribunal_case.pdf_generation_status.include?('CLOSURE')
      ClosureCaseRebuildsController.new
    elsif tribunal_case.pdf_generation_status.present?
      raise StandardError, "Pdf generation status #{
          tribunal_case.pdf_generation_status} not found"
    end
  end
end
