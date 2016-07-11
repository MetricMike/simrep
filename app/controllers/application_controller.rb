class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit

  def after_sign_in_path_for(resource)
    characters_path
  end

  # before_action :configure_permitted_parameters, if: :devise_controller?

  def switch_chapter
    session[:current_chapter_id] = current_chapter == Chapter::BASTION ? Chapter::HOLURHEIM.id : Chapter::BASTION.id
    redirect_back(fallback_location: root_path)
  end

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) << :name
  #   devise_parameter_sanitizer.for(:account_update) << :name
  # end

  def pundit_user
    UserWithContext.new(current_user, current_character, current_chapter)
  end

  def current_chapter
    @chapter ||= Chapter.where(id: session[:current_chapter_id]).try(:first) || Chapter::BASTION
  end
  helper_method :current_chapter

  def current_character
    @character ||= session[:current_char_id] && Character.find(session[:current_char_id])
  end
  helper_method :current_character

  def authenticate_admin!
    redirect_to root_path unless current_user && current_user.admin?
  end

  private

  def user_not_authorized
    flash[:error] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
