# frozen_string_literal: true

FactoryBot.define do
  factory :processing_log do
    filename { "email_#{rand(1..100)}.eml" }
    sender { Faker::Internet.email }
    status { 'success' }
    extracted_data { { name: Faker::Name.name, email: Faker::Internet.email }.to_json }
    processed_at { Time.current }
    customer

    trait :failed do
      status { 'failed' }
      error_message { 'Missing contact information' }
      customer { nil }
    end

    trait :without_customer do
      customer { nil }
    end
  end
end
