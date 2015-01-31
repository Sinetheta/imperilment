class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  skip_before_filter :verify_authenticity_token, :only => [:google]

  def google
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    remember_me(@user)

    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
    sign_in_and_redirect @user, :event => :authentication
  end
end
