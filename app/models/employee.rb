class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  scope :active_list, -> { where('last_sign_in_at > ?', 3.months.ago) }
  scope :inactive_list, -> { where('last_sign_in_at <= ? OR last_sign_in_at IS NULL', 3.months.ago) }

  validates :full_name, presence: true
  validates :password, presence: true

  def admin?
    role == 'admin'
  end

  def active?
    return false if last_sign_in_at.nil?
    last_sign_in_at > 3.months.ago
  end
end
