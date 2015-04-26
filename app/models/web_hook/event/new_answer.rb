require 'json'

class WebHook::Event::NewAnswer < WebHook::Event

  def initialize answer
    super(answer)
  end

  def action
    'new'
  end

  def type
    'answer'
  end

  protected
  def template
    'answers/show'
  end
end
