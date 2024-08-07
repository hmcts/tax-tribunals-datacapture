module Steps::Details
  class SendApplicationDetailsForm < BaseForm
    TRIBUNAL_CASE_ENTITY_MAPPING = {
      UserType::TAXPAYER       => :send_taxpayer_copy,
      UserType::REPRESENTATIVE => :send_representative_copy
    }

    attribute :send_application_details, String
    attribute :email_address, NormalisedEmail
    attribute :phone_number, StrippedString
    attr_accessor :send_to

    def self.choices
      SendApplicationDetails.values.map(&:to_s)
    end

    validate :selected_option
    validates_presence_of :email_address, if: :send_email_copy?
    validate :email_address_identical, if: :send_email_copy?
    validates_presence_of :phone_number, if: :send_text_copy?
    validate :phone_number_identical, if: :send_text_copy?

    def send_email_copy?
      send_application_details&.to_s.in?(['email', 'both'])
    end

    def send_text_copy?
      send_application_details&.to_s.in?(['text', 'both'])
    end

    private

    def selected_option
      if self.class.choices.exclude?(send_application_details)
        errors.add(:send_application_details, tribunal_case_entity, message: 'what are your contact preferences?')
      end
    end

    def email_address_identical
      return if errors.present?
      if saved_email != email_address
        key = :"different_#{send_to}"
        errors.add(:email_address, key, message: "#{send_to.to_s.capitalize}'s email does not match entered email address")
      end
    end

    def phone_number_identical
      return if errors.present?
      if saved_phone_number.present? && (saved_phone_number != phone_number)
        key = :"different_#{send_to}"
        errors.add(:phone_number, key, message: "#{send_to.to_s.capitalize}'s phone number does not match entered phone number")
      end
    end

    def saved_email
      if send_to == UserType::TAXPAYER
        tribunal_case.taxpayer_contact_email
      else
        tribunal_case.representative_contact_email
      end
    end

    def saved_phone_number
      if send_to == UserType::TAXPAYER
        tribunal_case.taxpayer_contact_phone
      else
        tribunal_case.representative_contact_phone
      end
    end

    def entity_contact_phone
      if send_to == UserType::TAXPAYER
        :taxpayer_contact_phone
      else
        :representative_contact_phone
      end
    end

    def send_application_details_value
      SendApplicationDetails.new(send_application_details)
    end

    def tribunal_case_entity
      TRIBUNAL_CASE_ENTITY_MAPPING[send_to]
    end

    def tribunal_case_entity_value
      tribunal_case.send(tribunal_case_entity)
    end

    def changed?
      tribunal_case_entity_value != send_application_details_value
    end

    def persist!
      raise 'No TribunalCase given' unless tribunal_case
      return true unless changed?

      additional_attributes = {}
      if send_text_copy? && saved_phone_number.blank?
        additional_attributes[entity_contact_phone] = phone_number
      end

      # or send_representative_copy: send_application_details_value
      tribunal_case.update({
        tribunal_case_entity => send_application_details_value
      }.merge(additional_attributes))
    end
  end
end
