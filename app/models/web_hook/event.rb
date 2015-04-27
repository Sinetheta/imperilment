require 'json'

class WebHook::Event
  attr_reader :type, :action

  def initialize payload=nil
    @payload = payload
  end

  def serialize
    to_json
  end

  private
  def to_json
    json = RablRails.render(@payload, template, view_path: 'app/views', format: :json)
    {
      type: type,
      action: action,
      type => JSON.parse(json)
    }.to_json
  end
end
