if ENV['MTOWER'].present? && !(defined? Rails::Console)
  require 'rack-mini-profiler'
  require 'memory_profiler'
  require 'flamegraph'
  require 'stackprof'

  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
