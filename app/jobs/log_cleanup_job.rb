# frozen_string_literal: true

# Background job for cleaning old processing logs
# Removes logs older than 30 days
class LogCleanupJob
  include Sidekiq::Job

  sidekiq_options retry: 2, queue: :low

  def perform(days_to_keep = 30)
    cutoff_date = days_to_keep.days.ago
    
    deleted_count = ProcessingLog.where('created_at < ?', cutoff_date).delete_all
    
    Rails.logger.info("Cleaned up #{deleted_count} processing logs older than #{days_to_keep} days")
  end
end
