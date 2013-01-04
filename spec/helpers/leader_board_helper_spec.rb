require 'spec_helper'

describe LeaderBoardHelper do
  describe '.rank_class' do
    subject { helper.rank_class(rank) }
    context 'when the rank is 0' do
      let(:rank) { 0 }
      it { should == 'gold' }
    end
    context 'when the rank is 1' do
      let(:rank) { 1 }
      it { should == 'silver' }
    end
    context 'when the rank is 2' do
      let(:rank) { 2 }
      it { should == 'bronze' }
    end
    context 'when the rank anything else' do
      let(:rank) { 3 }
      it { should == '' }
    end
  end
end
