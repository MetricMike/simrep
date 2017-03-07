if ENV['MTOWER'].present?
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
