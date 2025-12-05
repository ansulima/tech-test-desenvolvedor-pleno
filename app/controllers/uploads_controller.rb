# frozen_string_literal: true

class UploadsController < ApplicationController
  def index
  end

  def create
    uploaded_file = params[:email_file]

    unless uploaded_file
      redirect_to uploads_path, alert: 'Please select a file to upload'
      return
    end

    unless uploaded_file.original_filename.end_with?('.eml')
      redirect_to uploads_path, alert: 'Only .eml files are allowed'
      return
    end

    email_file = EmailFile.create!(
      filename: uploaded_file.original_filename,
      content: uploaded_file.read,
      content_type: uploaded_file.content_type,
      file_size: uploaded_file.size
    )

    EmailProcessorJob.perform_async(email_file.id)

    redirect_to uploads_path, notice: 'Email file uploaded successfully and is being processed in background'
  rescue StandardError => e
    redirect_to uploads_path, alert: "Error uploading file: #{e.message}"
  end
end
