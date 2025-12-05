# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailProcessorJob, type: :job do
  describe '#perform' do
    let(:email_file) { create(:email_file) }

    it 'processes the email file' do
      expect_any_instance_of(EmailProcessorService).to receive(:process).and_call_original

      described_class.new.perform(email_file.id)
    end

    it 'creates a customer from the email' do
      expect {
        described_class.new.perform(email_file.id)
      }.to change(Customer, :count).by(1)
    end

    it 'creates a processing log' do
      expect {
        described_class.new.perform(email_file.id)
      }.to change(ProcessingLog, :count).by(1)
    end

    context 'when email file is not found' do
      it 'logs an error' do
        expect(Rails.logger).to receive(:error).with(/EmailFile not found/)

        described_class.new.perform(999999)
      end
    end
  end
end
