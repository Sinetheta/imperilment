class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  check_authorization unless: :devise_controller?

  before_action do
    if params[:profile]
      Rack::MiniProfiler.authorize_request
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      message = exception.message
      format.html { redirect_to login_path }
      format.json { render json: { error: 'forbidden', message: message }, status: :forbidden }
      format.xml  { render xml:  { error: 'forbidden', message: message }, status: :forbidden }
    end
  end
end
