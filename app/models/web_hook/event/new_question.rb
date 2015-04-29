require 'json'

class WebHook::Event::NewQuestion < WebHook::Event

  def initialize answer
    super(answer)
  end

  def action
    'new'
  end

  def type
    'question'
  end

  protected
  def template
    'questions/show'
  end
end
