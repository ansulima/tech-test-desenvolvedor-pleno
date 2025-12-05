# frozen_string_literal: true

FactoryBot.define do
  factory :email_file do
    filename { "test_email.eml" }
    content { File.read(Rails.root.join('emails', 'email1.eml')) }
    content_type { 'message/rfc822' }
    file_size { content.bytesize }
  end
end
