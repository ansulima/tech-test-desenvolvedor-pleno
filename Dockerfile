FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    nodejs \
    postgresql-client \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Precompile assets (if needed)
# RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start the server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
