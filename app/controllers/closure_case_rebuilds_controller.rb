class ClosureCaseRebuildsController < GlimrCasesController
  include ApplicationHelper

  helper_method :current_tribunal_case

  attr_reader :presenter

  def current_tribunal_case=(tribunal_case)
    @current_tribunal_case = tribunal_case
    @presenter = presenter_class.new(tribunal_case, format: :pdf, locale: I18n.default_locale)
  end

  def pdf_template
    'steps/closure/check_answers/show'
  end

  def presenter_class
    CheckAnswers::ClosureAnswersPresenter
  end

  private

  def confirmation_path
    steps_closure_confirmation_path
  end
end
