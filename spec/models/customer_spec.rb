# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'associations' do
    it { should have_many(:processing_logs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }

    context 'email format' do
      it 'accepts valid email' do
        customer = build(:customer, email: 'test@example.com')
        expect(customer).to be_valid
      end

      it 'rejects invalid email' do
        customer = build(:customer, email: 'invalid-email')
        expect(customer).not_to be_valid
      end
    end

    context 'contact information' do
      it 'is valid with email only' do
        customer = build(:customer, email: 'test@example.com', phone: nil)
        expect(customer).to be_valid
      end

      it 'is valid with phone only' do
        customer = build(:customer, email: nil, phone: '11 91234-5678')
        expect(customer).to be_valid
      end

      it 'is valid with both email and phone' do
        customer = build(:customer, email: 'test@example.com', phone: '11 91234-5678')
        expect(customer).to be_valid
      end

      it 'is invalid without email or phone' do
        customer = build(:customer, email: nil, phone: nil)
        expect(customer).not_to be_valid
        expect(customer.errors[:base]).to include('Must have at least email or phone')
      end
    end
  end
end
