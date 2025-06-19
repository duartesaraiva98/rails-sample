Sentry.init do |config|
  config.dsn = "https://9e050e6871d08d541e5e155032f0e96e@o195517.ingest.us.sentry.io/4509429137997824"
  config.traces_sample_rate = 1.0
  # set the instrumenter to use OpenTelemetry instead of Sentry
  config.instrumenter = :otel
  config.environment = "duarte-dev"
end
