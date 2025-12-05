
require 'rails_helper'

RSpec.describe ProcessingLog, type: :model do
  describe 'associations' do
    it { should belong_to(:customer).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(%w[success failed]) }
  end

  describe 'scopes' do
    let!(:successful_log) { create(:processing_log, status: 'success') }
    let!(:failed_log) { create(:processing_log, status: 'failed') }

    it 'returns successful logs' do
      expect(ProcessingLog.successful).to include(successful_log)
      expect(ProcessingLog.successful).not_to include(failed_log)
    end

    it 'returns failed logs' do
      expect(ProcessingLog.failed).to include(failed_log)
      expect(ProcessingLog.failed).not_to include(successful_log)
    end

    it 'returns recent logs first' do
      expect(ProcessingLog.recent.first).to eq(failed_log)
    end
  end

  describe '#success?' do
    it 'returns true for successful status' do
      log = build(:processing_log, status: 'success')
      expect(log.success?).to be true
    end

    it 'returns false for failed status' do
      log = build(:processing_log, status: 'failed')
      expect(log.success?).to be false
    end
  end

  describe '#failed?' do
    it 'returns true for failed status' do
      log = build(:processing_log, status: 'failed')
      expect(log.failed?).to be true
    end

    it 'returns false for successful status' do
      log = build(:processing_log, status: 'success')
      expect(log.failed?).to be false
    end
  end
end
