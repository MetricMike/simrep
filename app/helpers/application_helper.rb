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

end
