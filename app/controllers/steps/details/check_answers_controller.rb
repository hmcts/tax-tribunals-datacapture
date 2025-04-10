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
          render_pdf summary, filename: pdf_filename
        end
      end
    end

    def resume
      @presenter = appeal_presenter
    end

    private

    def render_pdf(html, filename:)
      pdf = Grover.new(html, format: 'A4').to_pdf
      send_data pdf, filename:, type: "application/pdf"
    end

    def appeal_presenter
      CheckAnswers::AppealAnswersPresenter.new(current_tribunal_case, format: request.format.symbol, locale: I18n.locale)
    end

    def pdf_filename
      name_from_presenter = @presenter.pdf_filename
      name_from_presenter.include?('.pdf') ? name_from_presenter : "#{name_from_presenter}.pdf"
    end

  end
end
