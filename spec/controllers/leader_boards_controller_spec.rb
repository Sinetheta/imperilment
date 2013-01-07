require 'spec_helper'

describe LeaderBoardsController do
  authorize_and_login

  let(:game) { create :game }
  let(:user) { create :user }

  describe 'GET index' do
    before(:each) do
      get :index, game_id: game
    end

    it 'should assign the game to @game' do
      assigns(:game).should == game
    end

    it 'should assign the scores to @scores' do
      assigns(:scores).should == {0 => [{'user' => user, 'score' => 0}]}
    end
  end
end
