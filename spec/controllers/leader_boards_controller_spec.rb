require 'spec_helper'

describe LeaderBoardsController do
  let!(:game) { create :game, locked: true }
  let(:season) { game.ended_at.year }

  let(:result) { assigns(:results)[0] }

  describe 'GET index' do
    let!(:game_result) { create(:game_result, game: game, total: 300, position: 1) }

    context 'html' do
      it 'should assign the results to @results' do
        get :index, season: season
        expect(result).to eq(game_result.user)
        expect(result.total).to eq(300)
        expect(result.first).to eq(1)
        expect(result.second).to eq(0)
        expect(result.third).to eq(0)
      end
    end
    context 'json' do
      it 'should assign the results to @results' do
        get :index, season: season, format: :json
        expect(result).to eq(game_result.user)
      end
    end

    context 'with no season' do
      it 'should have the current year' do
        get :index
        expect(assigns(:season).year).to eq(Time.current.year)
      end
    end
    context 'with a season' do
      it 'should have the correct year' do
        # Everything before this was a mistake.
        get :index, season: 1776
        expect(assigns(:season).year).to eq(1776)

        # but I'm pretty sure imperilment wasn't inventes
        expect(assigns(:results)).to be_empty
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
      let!(:answer) { create :answer, game: game }
      let!(:question) { create :question, answer: answer }

      before(:each) do
        get :show, id: game.id, season: season
      end

      it 'should assign the game to @game' do
        expect(assigns(:game)).to eq(game)
      end

      it 'should assign the users to @results' do
        expect(result.user).to eq(question.user)
      end

      context 'when a game_id is passed' do
        let(:other_game) { create :game }
        before(:each) do
          get :show, game_id: other_game, season: season
        end
        it 'should assign the game to @game' do
          expect(assigns(:game)).to eq(other_game)
        end
      end
    end
  end

  describe "GET money" do
    let!(:game_result) { create(:game_result, game: game) }

    it 'should assign the results to @results' do
      get :money, season: season
      expect(result).to eq(game_result.user)
    end

    it 'should respond to html' do
      get :money, season: season
      expect(response).to be_success
    end

    it 'should respond to json' do
      get :money, season: season, format: :json
      expect(response).to be_success
    end
  end
end
