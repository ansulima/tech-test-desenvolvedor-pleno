
require 'rails_helper'

RSpec.describe EmailParsers::FornecedorAParser do
  let(:email_content) { File.read(Rails.root.join('emails', 'email1.eml')) }
  let(:parser) { described_class.new(email_content) }

  describe '#extract_customer_info' do
    it 'extracts all customer information correctly' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('João da Silva')
      expect(result[:email]).to eq('joao.silva@example.com')
      expect(result[:phone]).to eq('(11) 91234-5678')
      expect(result[:product_code]).to eq('ABC123')
      expect(result[:subject]).to eq('Pedido de orçamento - Produto ABC123')
    end
  end

  describe '#valid_contact_info?' do
    it 'returns true when email is present' do
      data = { email: 'test@example.com', phone: nil }
      expect(parser.valid_contact_info?(data)).to be true
    end

    it 'returns true when phone is present' do
      data = { email: nil, phone: '11 91234-5678' }
      expect(parser.valid_contact_info?(data)).to be true
    end

    it 'returns false when both are missing' do
      data = { email: nil, phone: nil }
      expect(parser.valid_contact_info?(data)).to be false
    end
  end

  context 'with email2.eml' do
    let(:email_content) { File.read(Rails.root.join('emails', 'email2.eml')) }

    it 'extracts customer information' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('Maria Oliveira')
      expect(result[:email]).to eq('maria.oliveira@example.com')
      expect(result[:phone]).to eq('21 99876-5432')
      expect(result[:product_code]).to eq('XYZ987')
    end
  end

  context 'with email3.eml (missing phone)' do
    let(:email_content) { File.read(Rails.root.join('emails', 'email3.eml')) }

    it 'extracts available information' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('Pedro Santos')
      expect(result[:email]).to eq('pedro.santos@example.com')
      expect(result[:phone]).to be_nil
      expect(result[:product_code]).to eq('LMN456')
    end

    it 'has valid contact info (email present)' do
      result = parser.extract_customer_info
      expect(parser.valid_contact_info?(result)).to be true
    end
  end
end
