source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Use opentelemetry for instrumentation
gem "opentelemetry-sdk", ">= 1.0"
# Use otlp exporter for otel instrumentation
gem 'opentelemetry-exporter-otlp'
# Use all auto instrumentation for otel
gem 'opentelemetry-instrumentation-all'
gem "sentry-ruby"
gem "sentry-rails"
gem "sentry-opentelemetry"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  # Use sqlite3 as the database for Active Record
  gem "sqlite3", ">= 2.1"
end

group :production do
  gem "pg"
end