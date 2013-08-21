require 'spec_helper'

describe GameResult do
  describe '::all_results' do
    before do
      GameResult.create! user_id: 1, position: 1
      GameResult.create! user_id: 1, position: 3
      GameResult.create! user_id: 1, position: 3
      GameResult.create! user_id: 1, position: 5
      GameResult.create! user_id: 2, position: 1
    end

    describe 'user 1' do
      subject { GameResult.all_results }

      specify { subject.first.first.should == 1 }
      specify { subject.first.second.should == 0 }
      specify { subject.first.third.should == 2 }
      specify { subject.last.first.should == 1 }
      specify { subject.last.second.should == 0 }
      specify { subject.last.third.should == 0 }
    end
  end
end
