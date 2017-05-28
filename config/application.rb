require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module SimRep
  class Application < Rails::Application
    config.time_zone = 'Eastern Time (US & Canada)'
    config.generators.test_framework false # Ugh, bad michael

    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_adapter = :sidekiq
  end
end
