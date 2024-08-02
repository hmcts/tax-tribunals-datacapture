class TaxTribs::RebuildPdf
  STATUS = TaxTribs::GroverPdf::STATUS

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
    presenter = controller_object.presenter_class

    TaxTribs::CaseDetailsPdf.new(tribunal_case, controller_object, presenter).
      generate_and_upload
  end

  def self.controller_for(tribunal_case)
    if tribunal_case.pdf_generation_status.include?('APPEAL')
      AppealCasesController.new
    elsif tribunal_case.pdf_generation_status.include?('CLOSURE')
      ClosureCasesController.new
    elsif tribunal_case.pdf_generation_status.present?
      raise StandardError, "Pdf generation status #{
          tribunal_case.pdf_generation_status} not found"
    end
  end
end
