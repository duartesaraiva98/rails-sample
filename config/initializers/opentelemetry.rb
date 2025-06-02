require "opentelemetry/sdk"
require 'opentelemetry/instrumentation/all'
require 'opentelemetry-exporter-otlp'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'boards'
  c.use_all
end

OtelTracer = OpenTelemetry.tracer_provider.tracer('nl.zorgdomein.boards')
