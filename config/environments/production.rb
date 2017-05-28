Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end


  config.consider_all_requests_local       = false

  config.cache_store = :redis_store, ENV['CACHE_URL']
  config.action_controller.perform_caching = true
  config.action_dispatch.rack_cache = {
    metastore: ENV['METASTORE_URL'],
    entitystore: ENV['ENTITYSTORE_URL']
  }

  config.action_mailer.default_url_options = { :host => 'simrep.simterra.net' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"

  config.action_mailer.smtp_settings = {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV["GMAIL_DOMAIN"],
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: ENV["GMAIL_USERNAME"],
    password: ENV["GMAIL_PASSWORD"]
  }

  config.assets.js_compressor = :uglifier
  config.assets.css_compressor = :sass

  config.assets.compile = false
  config.assets.digest = true
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
end
