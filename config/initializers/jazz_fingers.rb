if defined?(JazzFingers)
  JazzFingers.configure do |config|
    config.colored_prompt = false
    config.awesome_print = false
    config.coolline = false
  end

  require 'jazz_fingers/setup'
end