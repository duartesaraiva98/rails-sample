require "json"
require "logger"

class JsonLoggerFormatter
  def call(severity, time, progname, msg)
    log_entry = {
      timestamp: time.utc.iso8601,
      severity: severity,
    }

    case msg
    when Exception
      log_entry[:message] = "#{msg.class}: #{msg.message}"
      log_entry[:backtrace] = msg.backtrace&.join("\n")
    when Hash
      log_entry.merge!(msg)
    else
      log_entry[:message] = msg.to_s
    end

    "#{log_entry.to_json}\n"
  end
end

module JsonLogger
  attr_reader :logger

  @logger = Logger.new(STDOUT)
  @logger.formatter = JsonLoggerFormatter.new
end

Rails.logger = ActiveSupport::TaggedLogging.new(JsonLogger.logger)
Rails.logger.level = ENV["LOG_LEVEL"] || Logger::INFO
