module Steps::Appeal
  class CaseTypeForm < BaseForm
    include ActiveModel::Validations::Callbacks

    attribute :case_type, String
    attribute :case_type_more, String
    attribute :case_type_not_present, Boolean
    attribute :case_type_other_value, String

    def self.choices
      [
        CaseType::INCOME_TAX,
        CaseType::SELF_ASSESSMENT_LATE_PENALTY,
        CaseType::VAT,
        CaseType::CAPITAL_GAINS_TAX,
        CaseType::CORPORATION_TAX
      ].map(&:to_s)
    end

    def self.dropdown_choices
      CaseType.values.map(&:to_s) - CaseTypeForm.choices - [CaseType::OTHER].map(&:to_s)
    end

    before_validation :sanitize_case_type_more
    before_validation :clear_case_type_other_value
    after_validation :sanitize_case_type
    validates_presence_of :case_type_other_value, if: :case_type_not_present
    validate :case_type_present
    validate :only_one_case_type_selected
    validate :case_type_selected_with_not_present

    private

    def case_type_present
      return if case_type_not_present?

      unless CaseType.values.map(&:to_s).include?(case_type) || CaseType.values.map(&:to_s).include?(case_type_more)
        errors.add(:case_type, I18n.t('.activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type.inclusion'))
      end
    end

    def only_one_case_type_selected
      if case_type.present? && case_type_more.present?
        errors.add(:case_type_more, I18n.t('.activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type.multiple_selected'))
      end
    end

    def case_type_selected_with_not_present
      if (case_type.present? || case_type_more.present?) && case_type_other_value.present?
        errors.add(:case_type_not_present,
                   I18n.t('.activemodel.errors.models.steps/appeal/case_type_form.attributes.case_type.conflicted_selected'))
      end
    end

    def sanitize_case_type_more
      self.case_type_more = nil if case_type_more == "blank"
    end

    def clear_case_type_other_value
      self.case_type_other_value = nil if case_type_not_present.blank?
    end

    def sanitize_case_type
      self.case_type = case_type_more if case_type.blank?
      self.case_type_more = nil
    end

    def case_type_value
      return CaseType.find_constant('other') if case_type_other_value.present?
      return nil if case_type.blank?

      CaseType.find_constant(case_type)
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update(
        case_type: case_type_value,
        # The following are dependent attributes that need to be reset
        case_type_other_value: (case_type_other_value if case_type_not_present),
        challenged_decision: nil,
        challenged_decision_status: nil,
        dispute_type: nil,
        dispute_type_other_value: nil,
        penalty_level: nil,
        penalty_amount: nil,
        tax_amount: nil
      )
    end
  end
end
