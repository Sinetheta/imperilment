require 'spec_helper'

describe TitleHelper do
  describe '.title' do
    before(:each) do
      titles.each { |text| helper.title(text) }
    end

    context 'just one title' do
      let(:titles) { ['just_one'] }
      specify { expect(helper.title).to eq(titles) }
    end

    context 'multiple titles' do
      let(:titles) { ['first', 'second'] }
      specify { expect(helper.title).to eq(titles) }
    end
  end
end
