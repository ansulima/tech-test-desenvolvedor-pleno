
class EmailProcessorJob
  include Sidekiq::Job

  sidekiq_options retry: 3, queue: :default

  def perform(email_file_id)
    email_file = EmailFile.find(email_file_id)
    
    processor = EmailProcessorService.new(
      email_file.content,
      email_file.filename
    )
    
    result = processor.process
    
    Rails.logger.info("Processed email #{email_file.filename}: #{result[:success] ? 'SUCCESS' : 'FAILED'}")
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("EmailFile not found: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Error processing email: #{e.message}")
    raise 
  end
end
