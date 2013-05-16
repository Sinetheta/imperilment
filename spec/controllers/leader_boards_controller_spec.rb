require 'spec_helper'

describe LeaderBoardsController do
  authorize_and_login

  let!(:game) { create :game, locked: true }
  let(:user) { create :user }

  describe 'GET index' do
    before(:each) do
      User.stub(:with_overall_score) { {0 => [user]} }
      get :index
    end

    it 'should assign the games to @games' do
      assigns(:games).should =~ [game]
    end

    it 'should assign the users to @users' do
      assigns(:users).should == {0 => [user]}
    end
  end

  describe 'GET show' do
    before(:each) do
      User.stub(:grouped_and_sorted_by_score).with(game) { {0 => [user]} }
      get :show
    end

    it 'should assign the game to @game' do
      assigns(:game).should == game
    end

    it 'should assign the users to @users' do
      assigns(:users).should == {0 => [user]}
    end

    context 'when a game_id is passed' do
      let(:other_game) { create :game }
      before(:each) do
        User.stub(:grouped_and_sorted_by_score).with(other_game)
        get :show, game_id: other_game
      end
      it 'should assign the game to @game' do
        assigns(:game).should == other_game
      end
    end
  end
end
