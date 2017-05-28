class PgHeroJob < ApplicationJob
  queue_as :default

  def perform(*args)
    PgHero.capture_query_stats
  end
end
