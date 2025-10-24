
# Dockerfile for Rails Application
FROM ruby:3.4.4

# Set environment variables
ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="/usr/local/bundle"

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  sqlite3 \
  npm

# Install Yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Install gems
RUN bundle install --without development test

# Copy application code
COPY . /app

# Precompile Rails assets
RUN bundle exec rails assets:precompile

# Expose Puma port
EXPOSE 3000

# Start the Rails server
CMD ["./entrypoint.sh"]