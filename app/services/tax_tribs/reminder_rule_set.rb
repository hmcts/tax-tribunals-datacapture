class TaxTribs::ReminderRuleSet
  attr_accessor :created_days_ago,
                :status,
                :status_transition_to,
                :email_template_id

  delegate :find_each, :count, to: :rule_query

  def initialize(created_days_ago:, status:, status_transition_to:, email_template_id:)
    @created_days_ago = created_days_ago
    @status = status
    @status_transition_to = status_transition_to
    @email_template_id = email_template_id
  end

  def self.first_reminder
    new(
      created_days_ago: Rails.configuration.x.cases.expire_in_days - 5,
      status: nil,
      status_transition_to: CaseStatus::FIRST_REMINDER_SENT,
      email_template_id: :first_reminder
    )
  end

  def self.last_reminder
    new(
      created_days_ago: Rails.configuration.x.cases.expire_in_days - 1,
      status: CaseStatus::FIRST_REMINDER_SENT,
      status_transition_to: CaseStatus::LAST_REMINDER_SENT,
      email_template_id: :last_reminder
    )
  end

  private

  def rule_query
    TribunalCase.
      with_owner.
      where(case_status: status).
      where('created_at <= ?', created_days_ago.days.ago)
  end
end
