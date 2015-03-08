class WebHooksController < ApplicationController
  load_and_authorize_resource

  respond_to :html

  def index
    @web_hooks = @web_hooks.order(active: :desc, created_at: :desc)
    respond_with(@web_hooks)
  end

  def new
    @web_hook = WebHook.new
    respond_with(@web_hook)
  end

  def create
    @web_hook = WebHook.new(web_hook_params)
    if @web_hook.save
      flash.notice = t :model_create_successful, model: WebHook.model_name.human
      redirect_to action: :index
    else
      respond_with @web_hook
    end
  end

  private
  def web_hook_params
    params.require(:web_hook).permit(:url, :active)
  end
end
