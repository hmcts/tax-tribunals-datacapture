module Steps::Details
  class CheckAnswersController < Steps::DetailsStepController
    before_action :authenticate_user!, only: [:resume]

    def show
      @presenter = appeal_presenter

      respond_to do |format|
        format.html
        format.pdf do
          summary = render_to_string(
            template: "steps/details/check_answers/show",
            formats: [:pdf],
            handlers: [:erb],
            layout: false
          )
          render_pdf summary, filename: @presenter.pdf_filename
        end
      end
    end

    def resume
      @presenter = appeal_presenter
    end

    private

    def render_pdf(html, filename:)
      pdf = WickedPdf.new.pdf_from_string(html)
      send_data pdf, filename:, type: "application/pdf"
    end

    def appeal_presenter
      CheckAnswers::AppealAnswersPresenter.new(current_tribunal_case, format: request.format.symbol, locale: I18n.locale)
    end
  end
end
