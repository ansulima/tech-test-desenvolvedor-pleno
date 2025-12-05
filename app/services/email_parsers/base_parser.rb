# frozen_string_literal: true

module EmailParsers
  # Base class for all email parsers
  # Defines the interface that all parsers must implement
  class BaseParser
    attr_reader :email_content, :mail_object

    def initialize(email_content)
      @email_content = email_content
      @mail_object = Mail.read_from_string(email_content)
    end

    # Returns the sender email address
    def sender
      mail_object.from&.first
    end

    # Returns the subject
    def subject
      mail_object.subject
    end

    # Returns the email body as plain text
    def body
      if mail_object.multipart?
        mail_object.text_part&.decoded || mail_object.html_part&.decoded || ""
      else
        mail_object.decoded
      end
    end

    # Main method to extract customer information
    # Must be implemented by subclasses
    # Returns a hash with: { name:, email:, phone:, product_code:, subject: }
    def extract_customer_info
      raise NotImplementedError, "#{self.class} must implement #extract_customer_info"
    end

    # Validates if the extracted data has at least one contact method
    def valid_contact_info?(data)
      data[:email].present? || data[:phone].present?
    end

    protected

    # Helper method to extract email addresses from text
    def extract_email(text)
      email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/
      text.scan(email_regex).first
    end

    # Helper method to extract phone numbers from text
    # Supports Brazilian phone formats
    def extract_phone(text)
      phone_regex = /(?:\+?55\s?)?(?:\(?\d{2}\)?\s?)?9?\d{4}[-\s]?\d{4}/
      text.scan(phone_regex).first&.strip
    end

    # Helper method to extract product codes
    def extract_product_code(text)
      # Looks for patterns like ABC123, PROD-555, XYZ987, etc.
      product_regex = /\b[A-Z]{3,4}[-]?\d{3,4}\b/
      text.scan(product_regex).first
    end
  end
end
