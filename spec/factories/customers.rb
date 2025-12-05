# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    product_code { "#{('A'..'Z').to_a.sample(3).join}#{rand(100..999)}" }
    subject { Faker::Lorem.sentence }

    trait :with_email_only do
      phone { nil }
    end

    trait :with_phone_only do
      email { nil }
    end

    trait :without_contact do
      email { nil }
      phone { nil }
    end
  end
end
