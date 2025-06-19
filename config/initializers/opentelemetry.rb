require "opentelemetry/sdk"
require 'opentelemetry/instrumentation/all'
require 'opentelemetry-exporter-otlp'

OpenTelemetry::SDK.configure do |c|
  c.service_name = "test-openetelemetry"
  c.use_all
  c.add_span_processor(Sentry::OpenTelemetry::SpanProcessor.instance)
end

OpenTelemetry.propagation = Sentry::OpenTelemetry::Propagator.new

OtelTracer = OpenTelemetry.tracer_provider.tracer('nl.zorgdomein')
