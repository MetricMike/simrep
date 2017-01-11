Rollbar.configure do |config|
  # Without configuration, Rollbar is enabled in all environments.
  # To disable in specific environments, set config.enabled=false.

  config.access_token = ENV['ROLLBAR_SV_TOKEN']
  if Rails.env.test? # || Rails.env.development?
    config.enabled = false
    config.js_enabled = false
  end

  # These are probably VERY restrictive, but the default js_options burn
  # through 5k errors in 30 seconds.
  config.js_options = {
    itemsPerMinute: 1,
    maxItems: 5,
    reportLevel: "error",
    accessToken: ENV['ROLLBAR_CL_TOKEN'],
    ignoredMessages: [],
    captureUncaught: true,
    payload: {
      environment: Rails.env
    }
  }


  # Default ignores from AirBrake
  config.exception_level_filters.merge!({
    'AbstractController::ActionNotFound' => 'ignore',
    'ActiveRecord::RecordNotFound' => 'ignore',
    'ActionController::RoutingError' => 'ignore',
    'ActionController::InvalidAuthenticityToken' => 'ignore',
    'ActionController::UnknownAction' => 'ignore',
    'ActionController::UnknownHttpMethod' => 'ignore',
    'CGI::Session::CookieStore::TamperedWithCookie' => 'ignore',
    'Mongoid::Errors::DocumentNotFound' => 'ignore',
    'ActionController::UnknownFormat' => 'ignore',
    'Exceptions::APIRejected' => 'ignore'
  })

  config.dj_threshold = 2

  # This is a very naive attempt at rate-limiting because Rollbar doesn't do any client-side
  # processing and as an item-limited service, that's rather expensive.
  #
  # If the same error occurs for the same person in the same context on the
  # same server (not the same passenger instance) within the last five
  # minutes, ignore it.
  rate_limiter = proc do |options|
    scope = options[:scope]

    item = {
      person: scope[:person],
      context: scope[:context],
      exception: options[:exception],
      message: options[:message]
    }

    item_hash = item.hash

    possible_dup = Rails.cache.read(item_hash)
    if possible_dup.present?
      # Note: A duplicate item only checks the last 5 minutes. If an item
      # occurs at 9:52am, 9:55am, and 9:58am, the 9:52am and 9:58am items
      # will both be reported.
      raise Rollbar::Ignore if item_hash == possible_dup
    else
      Rails.cache.write(item_hash, item, expires_in: 5.minutes)
    end
  end
  config.before_process << rate_limiter

end

# More informative errors for common reponse codes
module Rollbar
  class Notifier

    # I only want to log a link if successful.
    def log_instance_link(data)
    end

    def handle_response(response)
      res_b = Rollbar::JSON.load(response.body)
      case response.code
      when '200'
        log_info '[Rollbar] Success'
        # Let rollbar.com generate the uuid
        log_info "[Rollbar] Details: #{Util.uuid_rollbar_url({uuid: res_b['result']['uuid']}, configuration)}"
      else
        log_info '[Rollbar] Failure'
        log_info "[Rollbar] Code: #{response.code}"
        log_info "[Rollbar] Message: #{res_b['message']}"
      end
    end
  end
end
