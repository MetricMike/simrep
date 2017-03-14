if ENV['MTOWER'].present?
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
