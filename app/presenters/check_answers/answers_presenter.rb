module CheckAnswers
  class AnswersPresenter
    attr_reader :tribunal_case, :format, :locale

    def initialize(tribunal_case, format: :html, locale: I18n.default_locale)
      @tribunal_case = tribunal_case
      @format = format
      @locale = locale
    end

    def case_reference?
      case_reference.present?
    end

    delegate :case_reference, to: :tribunal_case

    def pdf_params
      { pdf: pdf_filename, footer: { right: '[page]' } }
    end

    def pdf_filename
      [tribunal_case.case_reference, taxpayer_name_for_filename].compact.join('_').tr('/', '_')
    end

    private

    def pdf?
      format == :pdf
    end

    def taxpayer_name_for_filename
      [
        tribunal_case.taxpayer_individual_first_name,
        tribunal_case.taxpayer_individual_last_name,
        tribunal_case.taxpayer_organisation_name
      ].compact.join.gsub(/\s+/, '')
    end
  end
end
