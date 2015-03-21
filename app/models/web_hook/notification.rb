require 'net/http'

class WebHook::Notification
  def initialize web_hook, event
    @web_hook = web_hook
    @event = event
  end

  def deliver
    http = Net::HTTP.new(web_hook.uri.host, web_hook.uri.port)
    http.post(web_hook.uri.path, @event.serialize, json_headers)
  end

  private
  attr_reader :event, :web_hook

  def json_headers
    {
      'Content-Type' => 'application/json'
    }
  end
end
