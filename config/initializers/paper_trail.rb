PaperTrail.config.track_associations = false

if defined?(::Rails::Console)
  PaperTrail.request.whodunnit = "#{`whoami`.strip}: console"
elsif File.basename($0) == "rake"
  PaperTrail.request.whodunnit = "#{`whoami`.strip}: rake #{ARGV.join ' '}"
end