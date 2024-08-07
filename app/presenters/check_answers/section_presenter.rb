module CheckAnswers
  class SectionPresenter
    include Rails.application.routes.url_helpers

    attr_reader :tribunal_case, :locale

    def initialize(tribunal_case, locale: I18n.default_locale)
      @tribunal_case = tribunal_case
      @locale = locale
    end

    def default_url_options
      { locale:}
    end

    # Used by Rails to determine which partial to render
    def to_partial_path
      'section'
    end

    # May be overridden in subclasses to hide/show if appropriate
    def show?
      answers.any?
    end

    protected

    # :nocov:
    def answers
      raise 'must be implemented in subclasses'
    end
    # :nocov:

    def what_support
      [
        :language_interpreter,
        :sign_language_interpreter,
        :hearing_loop,
        :disabled_access,
        :other_support
      ].select { |support| tribunal_case[support] }
    end

    def what_support_with_details
      what_support.map do |attribute|
        attribute_details = "#{attribute}_details"
        if tribunal_case.respond_to?(attribute_details)
          [attribute, tribunal_case.send(attribute_details)]
        else
          attribute
        end
      end
    end
  end
end
