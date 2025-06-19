sentry_dsn = ENV.fetch('SENTRY_DSN') do
  raise "Missing required environment variable: SENTRY_DSN"
end

Sentry.init do |config|
  config.dsn = sentry_dsn
  config.traces_sample_rate = 1.0
  # set the instrumenter to use OpenTelemetry instead of Sentry
  config.instrumenter = :otel
  config.environment = "duarte-dev"
end
