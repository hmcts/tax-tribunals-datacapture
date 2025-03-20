class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  scope :active_list, -> { where('last_sign_in_at > ?', 3.months.ago) }
  scope :inactive_list, -> { where('last_sign_in_at <= ? OR last_sign_in_at IS NULL', 3.months.ago) }

  scope :default_order, lambda {
    order(Arel.sql(<<-SQL.squish))
      CASE
        WHEN last_sign_in_at > '#{3.months.ago}' AND role = 'admin' THEN 1
        WHEN last_sign_in_at > '#{3.months.ago}' AND role = 'user' THEN 2
        WHEN (last_sign_in_at <= '#{3.months.ago}' OR last_sign_in_at IS NULL) AND role = 'admin' THEN 3
        ELSE 4
      END
    SQL
  }
  validates :full_name, presence: true

  def admin?
    role == 'admin'
  end

  def active?
    return false if last_sign_in_at.nil?
    last_sign_in_at > 3.months.ago
  end
end
