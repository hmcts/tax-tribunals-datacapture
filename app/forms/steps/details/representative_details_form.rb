module Steps::Details
  class RepresentativeDetailsForm < BaseForm
    attribute :representative_contact_address, StrippedString
    attribute :representative_contact_postcode, StrippedString
    attribute :representative_contact_city, StrippedString
    attribute :representative_contact_country, StrippedString
    attribute :representative_contact_email, NormalisedEmail
    attribute :representative_contact_phone, StrippedString

    validates_presence_of :representative_contact_address,
                          :representative_contact_postcode,
                          :representative_contact_city,
                          :representative_contact_country,
                          :representative_contact_email

    # rubocop:disable Lint/LiteralAsCondition
    validate :special_chars_in_mail if :started_by_representative_or_present?
    validate :email_too_long if :started_by_representative_or_present?
    validates :representative_contact_email, presence: true, 'valid_email_2/email': true, if: :extra_email_validation?
    validate :valid_phone_number
    # rubocop:enable Lint/LiteralAsCondition

    private

    delegate :started_by_representative?, to: :tribunal_case

    def started_by_representative_or_present?
      started_by_representative? || representative_contact_email.present?
    end

    def extra_email_validation?
      started_by_representative_or_present? && errors.details[:representative_contact_email].blank?
    end

    def special_chars_in_mail
      return if representative_contact_email.blank?

      if /[;&()!\/*]/i.match?(representative_contact_email)
        errors.add :representative_contact_email, I18n.t('errors.messages.email.special_characters')
      end
    end

    def email_too_long
      return if representative_contact_email.blank?
      if representative_contact_email.length > 256
        errors.add :representative_contact_email, I18n.t('errors.messages.email.too_long')
      end
    end

    def valid_phone_number
      return if representative_contact_phone.blank?

      phone_number = representative_contact_phone.gsub(/[-() ]/, '')
      if phone_number =~ /\D/ || representative_contact_phone =~ /[*!&\/;]/
        errors.add :representative_contact_phone, I18n.t('errors.messages.phone.invalid_characters')
      end
    end

    def persist!(additional_attributes)
      raise 'No TribunalCase given' unless tribunal_case

      tribunal_case.update({
        representative_contact_address:,
        representative_contact_postcode:,
        representative_contact_city:,
        representative_contact_country:,
        representative_contact_email:,
        representative_contact_phone:
      }.merge(additional_attributes))
    end
  end
end
