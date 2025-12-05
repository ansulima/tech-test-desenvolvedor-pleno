class Customer < ApplicationRecord
  has_many :processing_logs

  validates :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validate :must_have_contact_info

  private

  def must_have_contact_info
    if email.blank? && phone.blank?
      errors.add(:base, "Must have at least email or phone")
    end
  end
end
