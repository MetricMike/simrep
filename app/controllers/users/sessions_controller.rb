class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    if data = session['devise.facebook_data']
      user = User.find_by(email: params['user']['email'])
      user.update(provider: data['provider'], uid: data['uid'])
    end
    session.merge! current_chapter_id: Chapter.find_by(name: params[:commit]).try(:id) || 1
    super
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
