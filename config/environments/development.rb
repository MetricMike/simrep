Rails.application.configure do

  BetterErrors::Middleware.allow_ip! '172.16.0.0/12'

  config.action_mailer.default_url_options = { host: 'localhost', port: ENV['PORT'] }
  config.action_mailer.delivery_method = :letter_opener_web

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local       = true

  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load

  config.sass.inline_source_maps = true
  config.assets.debug = true
  config.assets.quiet = false

  config.assets.raise_runtime_errors = true

end
