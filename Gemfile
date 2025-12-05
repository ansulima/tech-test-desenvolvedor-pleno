source "https://rubygems.org"

gem "rails", "7.1.5.1"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem "image_processing", "~> 1.2"

# Background jobs
gem "connection_pool", "~> 2.4"
gem "sidekiq", "~> 6.5"

# Email parsing
gem "mail", "~> 2.8"

# Pagination
gem "kaminari", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.2"
  gem "shoulda-matchers", "~> 5.3"
end

group :development do
  gem "web-console"
end

group :test do
  gem "simplecov", require: false
  gem "database_cleaner-active_record"
end
