if defined?(JazzFingers)
  JazzFingers.configure do |config|
    config.colored_prompt = true
    config.awesome_print = true
  end

  require 'jazz_fingers/setup'
end