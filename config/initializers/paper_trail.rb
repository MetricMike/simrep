# the following line is required for PaperTrail >= 4.0.0 with Rails
PaperTrail::Rails::Engine.eager_load!

if defined?(::Rails::Console)
  PaperTrail.whodunnit = "#{`whoami`.strip}: console"
elsif File.basename($0) == "rake"
  PaperTrail.whodunnit = "#{`whoami`.strip}: rake #{ARGV.join ' '}"
end