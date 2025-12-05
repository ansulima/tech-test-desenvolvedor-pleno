
module EmailParsers
  class ParceiroBParser < BaseParser
    def extract_customer_info
      body_text = body

      {
        name: extract_name(body_text),
        email: extract_email_field(body_text),
        phone: extract_phone_field(body_text),
        product_code: extract_product_code_field(body_text),
        subject: subject
      }
    end

    private

    def extract_name(text)
      name_match = text.match(/^(?:Cliente|Nome(?:\s+completo)?|Nome\s+do\s+cliente):\s*(.+?)$/i)
      name_match[1].strip if name_match
    end

    def extract_email_field(text)
      email_match = text.match(/E-?mail(?:\s+de\s+contato)?:\s*(.+?)(?:\n|$)/i)
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

    def extract_product_code_field(text)
      product_match = text.match(/(?:Produto(?:\s+de\s+interesse)?|Código\s+do\s+produto):\s*(.+?)(?:\n|$)/i)
      if product_match
        product_match[1].strip
      else
        extract_product_code(text)
      end
    end
  end
end
