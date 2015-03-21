class WebHook::Dispatch
  def initialize event, targets
    @event = event
    @targets = targets
  end

  def deliver
    @targets.each do |web_hook|
      WebHook::Notification.new(web_hook, @event).deliver
    end
  end

  private
  attr_reader :event
end
