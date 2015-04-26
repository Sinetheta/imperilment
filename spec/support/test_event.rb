class TestEvent < WebHook::Event
  def serialize
    'payload'
  end
end
