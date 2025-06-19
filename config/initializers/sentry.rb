Sentry.init do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', nil)
  config.traces_sample_rate = 1.0
  # set the instrumenter to use OpenTelemetry instead of Sentry
  config.instrumenter = :otel
  config.environment = "duarte-dev"
end
