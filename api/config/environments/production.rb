require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Cache classes and eager load code for performance
  config.cache_classes = true
  config.eager_load = true

  # Full error reports are disabled
  config.consider_all_requests_local = false

  # Serve static files if ENV is set (Render)
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.public_file_server.headers = { "Cache-Control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files locally
  config.active_storage.service = :local

  # Force SSL (optional; enable if using HTTPS)
  # config.force_ssl = true

  # Logging
  config.log_level = :info
  config.log_tags = [:request_id]
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Caching
  config.cache_store = :solid_cache_store

  # Background jobs
  config.active_job.queue_adapter = :solid_queue

  # I18n fallbacks
  config.i18n.fallbacks = true

  # Don't log deprecations
  config.active_support.report_deprecations = false

  # Don't dump schema after migrations
  config.active_record.dump_schema_after_migration = false
end
