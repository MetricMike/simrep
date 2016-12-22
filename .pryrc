# Docker containers don't have access to the default ~/.pry_history
Pry.config.history.file = "./.pry_history"

begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError => err
  puts "no awesome_print :("
end

begin
  require 'hirb'
rescue LoadError
  # Missing goodies, bummer
end
