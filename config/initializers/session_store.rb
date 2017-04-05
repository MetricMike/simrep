# Be sure to restart your server when you modify this file.

if Rails.env.production?
  Rails.application.config.session_store :redis_store, servers: ENV['SESSION_URL']
else # dev/test
  Rails.application.config.session_store :cookie_store
end
