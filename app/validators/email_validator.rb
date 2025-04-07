require 'uri'

class EmailValidator < ActiveModel::Validator
  def validate(record)
    if record.email.match? URI::MailTo::EMAIL_REGEXP
      nil
    else
      record.errors.add(:email, 'has an invalid format')
      raise ActiveRecord::Rollback
    end
  end
end
