# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailParsers::ParceiroBParser do
  let(:email_content) { File.read(Rails.root.join('emails', 'email4.eml')) }
  let(:parser) { described_class.new(email_content) }

  describe '#extract_customer_info' do
    it 'extracts all customer information correctly' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('Ana Costa')
      expect(result[:email]).to eq('ana.costa@example.com')
      expect(result[:phone]).to eq('+55 31 97777-1111')
      expect(result[:product_code]).to eq('PROD-555')
      expect(result[:subject]).to eq('Cliente interessado no PROD-555')
    end
  end

  context 'with email5.eml' do
    let(:email_content) { File.read(Rails.root.join('emails', 'email5.eml')) }

    it 'extracts customer information' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('Ricardo Almeida')
      expect(result[:email]).to eq('ricardo.almeida@example.com')
      expect(result[:phone]).to eq('41 98888-2222')
      expect(result[:product_code]).to eq('PROD-888')
    end
  end

  context 'with email6.eml (missing email)' do
    let(:email_content) { File.read(Rails.root.join('emails', 'email6.eml')) }

    it 'extracts available information' do
      result = parser.extract_customer_info

      expect(result[:name]).to eq('Fernanda Lima')
      expect(result[:email]).to be_nil
      expect(result[:phone]).to eq('61 93333-4444')
      expect(result[:product_code]).to eq('PROD-999')
    end

    it 'has valid contact info (phone present)' do
      result = parser.extract_customer_info
      expect(parser.valid_contact_info?(result)).to be true
    end
  end
end
