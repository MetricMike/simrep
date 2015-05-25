module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "SimRep"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def current_char
    @character ||= session[:current_char_id] && Character.find_by(id: session[:current_char_id ])
  end

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

end
