
require 'rails_helper'

RSpec.describe EmailProcessorService do
  describe '#process' do
    context 'with Fornecedor A email' do
      let(:email_content) { File.read(Rails.root.join('emails', 'email1.eml')) }
      let(:service) { described_class.new(email_content, 'email1.eml') }

      it 'successfully processes the email' do
        result = service.process

        expect(result[:success]).to be true
        expect(result[:customer]).to be_persisted
        expect(result[:customer].name).to eq('João da Silva')
        expect(result[:customer].email).to eq('joao.silva@example.com')
      end

      it 'creates a processing log' do
        expect {
          service.process
        }.to change(ProcessingLog, :count).by(1)

        log = ProcessingLog.last
        expect(log.status).to eq('success')
        expect(log.filename).to eq('email1.eml')
        expect(log.sender).to eq('loja@fornecedorA.com')
      end
    end

    context 'with Parceiro B email' do
      let(:email_content) { File.read(Rails.root.join('emails', 'email4.eml')) }
      let(:service) { described_class.new(email_content, 'email4.eml') }

      it 'successfully processes the email' do
        result = service.process

        expect(result[:success]).to be true
        expect(result[:customer]).to be_persisted
        expect(result[:customer].name).to eq('Ana Costa')
      end
    end

    context 'with email missing contact info' do
      let(:email_content) { File.read(Rails.root.join('emails', 'email7.eml')) }
      let(:service) { described_class.new(email_content, 'email7.eml') }

      it 'fails to process the email' do
        result = service.process

        expect(result[:success]).to be false
        expect(result[:error]).to include('contact information')
      end

      it 'creates a failed processing log' do
        service.process

        log = ProcessingLog.last
        expect(log.status).to eq('failed')
        expect(log.error_message).to include('contact information')
      end
    end

    context 'with unknown sender' do
      let(:email_content) do
        <<~EMAIL
          From: unknown@sender.com
          To: vendas@suaempresa.com
          Subject: Test

          Some content
        EMAIL
      end
      let(:service) { described_class.new(email_content, 'unknown.eml') }

      it 'fails to process the email' do
        result = service.process

        expect(result[:success]).to be false
        expect(result[:error]).to eq('Unknown sender')
      end

      it 'creates a failed processing log' do
        service.process

        log = ProcessingLog.last
        expect(log.status).to eq('failed')
        expect(log.error_message).to include('No parser found')
      end
    end
  end
end
