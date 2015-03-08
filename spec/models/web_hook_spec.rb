require 'spec_helper'

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

  it 'defaults to active' do
    web_hook = WebHook.new url: 'http://www.example.com'
    expect(web_hook.active).to be(true)
  end
end
