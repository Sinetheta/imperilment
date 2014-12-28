require 'spec_helper'

describe LeaderBoardsController do
  authorize_and_login

  let!(:game) { create :game, locked: true }
  let(:user) { create :user }

  describe 'GET index' do
    let(:game_results) { [GameResult.new] }
    before(:each) do
      allow(GameResult).to receive(:all_results) { game_results }
    end

    context 'html' do
      it 'should assign the results to @results' do
        get :index
        expect(assigns(:results)).to eq(game_results)
      end
    end
    context 'json' do
      it 'should assign the results to @results' do
        get :index, format: :json
        expect(assigns(:results)).to eq(game_results)
      end
    end
  end

  describe 'GET show' do
    context "games dont exist" do
      it 'shouldnt fail miserably with an exception' do
        Game.destroy_all
        get :show
        expect(assigns(:game)).to be_nil
      end
    end
    context "games exist" do
      before(:each) do
        allow_any_instance_of(Game).to receive(:grouped_and_sorted_by_score) { {0 => [user]} }
        get :show
      end

      it 'should assign the game to @game' do
        expect(assigns(:game)).to eq(game)
      end

      it 'should assign the users to @users' do
        expect(assigns(:results).first).to be_a(GameResult)
        expect(assigns(:results).first.user).to eq(user)
      end

      context 'when a game_id is passed' do
        let(:other_game) { create :game }
        before(:each) do
          allow(User).to receive(:grouped_and_sorted_by_score).with(other_game)
          get :show, game_id: other_game
        end
        it 'should assign the game to @game' do
          expect(assigns(:game)).to eq(other_game)
        end
      end
    end
  end

  describe "GET money" do
    let(:game_results) { [GameResult.new] }
    before(:each) do
      allow(GameResult).to receive(:all_results_by_money) { game_results }
    end

    it 'should assign the results to @results' do
      get :money
      expect(assigns(:results)).to eq(game_results)
    end

    it 'should respond to html' do
      get :money
      expect(response).to be_success
    end

    it 'should respond to json' do
      get :money, format: :json
      expect(response).to be_success
    end
  end
end




