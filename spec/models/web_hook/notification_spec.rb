require 'spec_helper'

describe WebHook::Notification do
  let(:web_hook) { build :web_hook }
  let(:event) { TestEvent.new }
  let(:notification) { WebHook::Notification.new(web_hook, event) }

  describe 'deliver' do
    let!(:mock) { stub_request(:any, web_hook.uri) }
    subject {
      notification.deliver
    }

    it 'POSTs to the uri' do
      subject
      expect(mock).to have_been_made
    end

    it 'delivers the payload' do
      subject
      expect(mock.with body: 'payload').to have_been_made
    end

    it 'specifies the content is json' do
      subject
      expect(mock.with headers: {'Content-Type'=>'application/json'}).to have_been_made
    end
  end
end
