# frozen_string_literal: true

module EmailParsers
  # Parser for emails from Fornecedor A (loja@fornecedorA.com)
  # Format:
  #   Nome do cliente: João da Silva
  #   E-mail: joao.silva@example.com
  #   Telefone: (11) 91234-5678
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
      # Looks for "Nome do cliente:" or "Nome:" patterns
      name_match = text.match(/Nome(?:\s+do\s+cliente)?:\s*(.+?)(?:\n|$)/i)
      name_match[1].strip if name_match
    end

    def extract_email_field(text)
      # Looks for "E-mail:" pattern
      email_match = text.match(/E-?mail:\s*(.+?)(?:\n|$)/i)
      if email_match
        email_match[1].strip
      else
        # Fallback to generic email extraction
        extract_email(text)
      end
    end

    def extract_phone_field(text)
      # Looks for "Telefone:" pattern
      phone_match = text.match(/Telefone:\s*(.+?)(?:\n|$)/i)
      if phone_match
        phone_match[1].strip
      else
        # Fallback to generic phone extraction
        extract_phone(text)
      end
    end
  end
end
