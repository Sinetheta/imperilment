class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      message = exception.message
      format.html { redirect_to user_omniauth_authorize_path(:google) }
      format.json { render json: {error: 'forbidden', message: message}, status: :forbidden }
      format.xml  { render xml:  {error: 'forbidden', message: message}, status: :forbidden }
    end
  end
end
