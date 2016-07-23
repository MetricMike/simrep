if !Rails.env.production?
  ActiveRecordQueryTrace.enabled = !Rails.env.production?
  ActiveRecordQueryTrace.level = :app # default
  ActiveRecordQueryTrace.ignore_cached_queries = true # Default is false.
end
