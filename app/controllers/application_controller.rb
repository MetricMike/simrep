class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :check_rack_mini_profiler
  before_action :set_paper_trail_whodunnit

  def check_rack_mini_profiler
      Rack::MiniProfiler.authorize_request
  end

  def after_sign_in_path_for(resource)
    characters_path
  end

  # before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) << :name
  #   devise_parameter_sanitizer.for(:account_update) << :name
  # end

  def pundit_user
    UserWithContext.new(current_user, current_character)
  end

  def current_character
    @character ||= session[:current_char_id] && Character.find(session[:current_char_id])
  end
  helper_method :current_character

  def authenticate_admin!
    redirect_to root_path unless current_user.try(:admin?)
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
