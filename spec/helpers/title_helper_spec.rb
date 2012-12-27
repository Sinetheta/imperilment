require 'spec_helper'

describe TitleHelper do
  describe '.title' do
    before(:each) do
      titles.each { |text| helper.title(text) }
    end

    context 'just one title' do
      let(:titles) { ['just_one'] }
      specify { helper.title.should == titles }
    end

    context 'multiple titles' do
      let(:titles) { ['first', 'second'] }
      specify { helper.title.should == titles }
    end
  end
end
