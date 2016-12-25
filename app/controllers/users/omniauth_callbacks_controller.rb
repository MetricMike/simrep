class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def developer
    @user = User.where(email: request.env["omniauth.auth"].info['email']).try(:first)
    if @user.nil?
      @user = User.create(   email:   request.env["omniauth.auth"].info['email'],
                              name:   request.env["omniauth.auth"].info['name'],
                          password:   Devise.friendly_token[0,20] )
    end
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:success, kind: "Local") if is_navigational_format?
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end