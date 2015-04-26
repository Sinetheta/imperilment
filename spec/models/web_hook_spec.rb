require 'spec_helper'
require 'uri'

describe WebHook do
  it 'has a valid factory' do
    expect(FactoryGirl.create :web_hook).to be_valid
  end

  it 'is invalid without a url' do
    expect(FactoryGirl.build :web_hook, url: nil).to_not be_valid
  end

  it 'is validates url format' do
    web_hook = FactoryGirl.build(:web_hook, url: 'CATS!')
    expect(web_hook).to_not be_valid
    expect(web_hook.errors[:url]).to eq(['is not a valid URL'])
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
