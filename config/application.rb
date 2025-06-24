require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsSample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.rails_semantic_logger.add_file_appender = false
    config.semantic_logger.add_appender(io: $stdout, formatter: :json)
    config.semantic_logger.application = ENV["APP_NAME"]
    config.rails_semantic_logger.quiet_assets = true
    config.rails_semantic_logger.started = false
    config.rails_semantic_logger.processing = false
    config.rails_semantic_logger.rendered = false
    config.log_tags = {
      trace_id: ->(_req) {
        ctx = OpenTelemetry::Trace.current_span.context
        ctx.valid? ? ctx.trace_id.unpack1("H*") : nil
      },
      span_id: ->(_req) {
        ctx = OpenTelemetry::Trace.current_span.context
        ctx.valid? ? ctx.span_id.unpack1("H*") : nil
      }
    }

    if ENV["LOG_LEVEL"].present?
      config.log_level = ENV["LOG_LEVEL"].downcase.strip.to_sym
    end
  end
end
