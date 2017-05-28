JSONAPI.configure do |config|
  config.default_processor_klass = JSONAPI::Authorization::AuthorizingProcessor
  config.exception_class_whitelist = [Pundit::NotAuthorizedError]
end

# JSONAPI::Authorization.configure do |config|
#   config.pundit_user = :pundit_user
# end
