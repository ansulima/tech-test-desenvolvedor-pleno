
module EmailParsers
  class FornecedorAParser < BaseParser
    def extract_customer_info
      body_text = body

      {
        name: extract_name(body_text),
        email: extract_email_field(body_text),
        phone: extract_phone_field(body_text),
        product_code: extract_product_code(body_text),
        subject: subject
      }
    end

    private

    def extract_name(text)
      name_match = text.match(/Nome(?:\s+do\s+cliente)?:\s*(.+?)(?:\n|$)/i)
      name_match[1].strip if name_match
    end

    def extract_email_field(text)
      email_match = text.match(/E-?mail:\s*(.+?)(?:\n|$)/i)
      if email_match
        email_match[1].strip
      else
        extract_email(text)
      end
    end

    def extract_phone_field(text)
      phone_match = text.match(/Telefone:\s*(.+?)(?:\n|$)/i)
      if phone_match
        phone_match[1].strip
      else
        extract_phone(text)
      end
    end
  end
end
