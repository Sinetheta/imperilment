class ApplicationController < ActionController::Base
  protect_from_forgery

  enable_authorization unless: :devise_controller?

  rescue_from CanCan::Unauthorized do |exception|
    respond_to do |format|
      message = exception.message
      format.html { render inline: %{<div class="alert alert-error alert-block"><h4>#{t('unauthorized.header')}</h4>#{message}</h1>}, layout: 'application' }
      format.json { render json: {error: 'forbidden', message: message}, status: :forbidden }
      format.xml  { render xml:  {error: 'forbidden', message: message}, status: :forbidden }
    end
  end
end
