class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def exception_in_span(logger, e)
    current_span = OpenTelemetry::Trace.current_span
    current_span.status = OpenTelemetry::Trace::Status.error(e.message)
    current_span.record_exception(e)
    logger.error(e.message, exception=e)
    Sentry.capture_exception(e)
  end
end
