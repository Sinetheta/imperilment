require 'spec_helper'
require 'uri'

describe WebHook do
  it 'has a valid factory' do
    expect(FactoryGirl.create :web_hook).to be_valid
  end

  it 'is invalid without a url' do
    expect(FactoryGirl.build :web_hook, url: nil).to_not be_valid
  end

  it 'creates a uri from the url' do
    expect(FactoryGirl.create(:web_hook).uri).to be_an(URI)
  end

  it 'defaults to active' do
    web_hook = WebHook.new url: 'http://www.example.com'
    expect(web_hook.active).to be(true)
  end

  it 'has an active scope' do
    active = FactoryGirl.create :web_hook
    inactive = FactoryGirl.create :web_hook, active: false
    expect(WebHook.active).to eq([active])
  end
end
