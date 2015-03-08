class WebHooksController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def index
    @web_hooks = @web_hooks.order(active: :desc, created_at: :desc)
    respond_with(@web_hooks)
  end
end
