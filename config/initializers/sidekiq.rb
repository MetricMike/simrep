sidekiq_config = { url: ENV['WORKER_URL'] }

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end

Sidekiq.default_worker_options = {
  unique: :until_timeout,
  unique_args: ->(args) { [ args.first.except('job_id') ] }
}
