class PgHeroJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PgHero.capture_query_stats
  end
end

Sidekiq::Cron::Job.create(name: 'PgHero Stats - every 5min', cron: '*/5 * * * *', class: 'PgHeroJob')
