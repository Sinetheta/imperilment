require 'spec_helper'

describe WebHook::Dispatch do
  let(:web_hook) { build :web_hook }
  let(:event) { TestEvent.new }
  let(:dispatch) { WebHook::Dispatch.new event, [web_hook] }

  describe 'deliver' do
    let!(:mock) { stub_request(:any, web_hook.uri) }
    subject { dispatch.deliver }

    it 'delivers a notification' do
      subject
      expect(mock).to have_been_made
    end
  end
end
