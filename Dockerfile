FROM ruby:3.4.4

ENV RAILS_ENV=production
ENV SECRET_KEY_BASE=7d54299f-cd61-4b2a-90b1-e241ed6d8956

WORKDIR /app

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    libsqlite3-dev \
    && apt-get clean

COPY Gemfile Gemfile.lock ./

RUN gem install bundler -v 2.6.7 && bundle install --deployment --without development

COPY . .

RUN bundle exec rails assets:precompile

RUN bundle exec rails db:migrate

# Expose port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]