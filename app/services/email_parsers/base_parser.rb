
module EmailParsers
  class BaseParser
    attr_reader :email_content, :mail_object

    def initialize(email_content)
      @email_content = email_content
      @mail_object = Mail.read_from_string(email_content)
    end

    def sender
      mail_object.from&.first
    end

    def subject
      mail_object.subject
    end

    def body
      if mail_object.multipart?
        mail_object.text_part&.decoded || mail_object.html_part&.decoded || ""
      else
        mail_object.decoded
      end
    end

    def extract_customer_info
      raise NotImplementedError, "#{self.class} must implement #extract_customer_info"
    end

    def valid_contact_info?(data)
      data[:email].present? || data[:phone].present?
    end

    protected

    def extract_email(text)
      email_regex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/
      text.scan(email_regex).first
    end

    def extract_phone(text)
      phone_regex = /(?:\+?55\s?)?(?:\(?\d{2}\)?\s?)?9?\d{4}[-\s]?\d{4}/
      text.scan(phone_regex).first&.strip
    end

    def extract_product_code(text)
      product_regex = /\b[A-Z]{3,4}[-]?\d{3,4}\b/
      text.scan(product_regex).first
    end
  end
end
