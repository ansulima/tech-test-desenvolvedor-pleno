# frozen_string_literal: true

module EmailParsers
  # Parser for emails from Parceiro B (contato@parceiroB.com)
  # Format:
  #   Cliente: Ana Costa
  #   Email: ana.costa@example.com
  #   Telefone: +55 31 97777-1111
  #   Produto de interesse: PROD-555
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
      # Looks for "Cliente:" or "Nome completo:" patterns at the beginning of a line
      name_match = text.match(/^(?:Cliente|Nome(?:\s+completo)?|Nome\s+do\s+cliente):\s*(.+?)$/i)
      name_match[1].strip if name_match
    end

    def extract_email_field(text)
      # Looks for "Email:" or "E-mail de contato:" patterns
      email_match = text.match(/E-?mail(?:\s+de\s+contato)?:\s*(.+?)(?:\n|$)/i)
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

    def extract_product_code_field(text)
      # Looks for "Produto de interesse:" or "Código do produto:" patterns
      product_match = text.match(/(?:Produto(?:\s+de\s+interesse)?|Código\s+do\s+produto):\s*(.+?)(?:\n|$)/i)
      if product_match
        product_match[1].strip
      else
        # Fallback to generic product code extraction
        extract_product_code(text)
      end
    end
  end
end
