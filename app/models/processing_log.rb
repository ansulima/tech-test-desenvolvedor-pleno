class ProcessingLog < ApplicationRecord
  belongs_to :customer, optional: true

  STATUSES = %w[success failed].freeze

  validates :filename, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  scope :recent, -> { order(created_at: :desc) }
  scope :successful, -> { where(status: 'success') }
  scope :failed, -> { where(status: 'failed') }

  def success?
    status == 'success'
  end

  def failed?
    status == 'failed'
  end
end
