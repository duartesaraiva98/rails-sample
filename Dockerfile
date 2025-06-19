# Use official Ruby image as base
FROM ruby:3.4.4

# Set working directory in container
WORKDIR /app

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    libsqlite3-dev \
    && apt-get clean

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 2.6.7 && bundle install

# Copy application code
COPY . .

# Precompile assets (optional for production builds)
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expose port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]