require "opentelemetry/sdk"
require "opentelemetry/instrumentation/all"
require "opentelemetry-exporter-otlp"

OpenTelemetry::SDK.configure do |c|
  exporter = OpenTelemetry::Exporter::OTLP::Exporter.new

  c.service_name = "rails-sample"
  c.use_all
  c.add_span_processor(Sentry::OpenTelemetry::SpanProcessor.instance)
  c.add_span_processor(OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(exporter))
end

OpenTelemetry.propagation = Sentry::OpenTelemetry::Propagator.new

OtelTracer = OpenTelemetry.tracer_provider.tracer("com.simple.tracer")
