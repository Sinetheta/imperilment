require 'spec_helper'

describe LeaderBoardsController do
  let!(:game) { create :game, locked: true, ended_at: Date.current.end_of_week }
  let(:season) { game.ended_at.cwyear }

  let(:result) { assigns(:results)[0] }

  describe 'GET index' do
    let!(:game_result) { create(:game_result, game: game, total: 300, position: 1) }

    context 'html' do
      it 'should assign the results to @results' do
        get :index, params: { season: season }
        expect(result).to eq(game_result.user)
        expect(result.total).to eq(300)
        expect(result.first).to eq(1)
        expect(result.second).to eq(0)
        expect(result.third).to eq(0)
      end
    end

    context 'json' do
      it 'should assign the results to @results' do
        get :index, params: { season: season, format: :json }
        expect(result).to eq(game_result.user)
      end
    end

    context 'with no season' do
      it 'should have the current year' do
        get :index
        expect(assigns(:season).year).to eq(Date.current.cwyear)
      end
    end
    context 'with a season' do
      it 'should have the correct year' do
        # Everything before this was a mistake.
        get :index, params: { season: 1776 }
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

      subject { get :show, params: { season: season } }

      it 'should assign the game to @game' do
        subject
        expect(assigns(:game)).to eq(game)
      end

      it 'should assign the users to @results' do
        subject
        expect(result.user).to eq(question.user)
      end

      context 'when a game_id is passed' do
        let(:other_game) { create :game }
        subject { get :show, params: { game_id: other_game, season: season } }
        it 'should assign the game to @game' do
          subject
          expect(assigns(:game)).to eq(other_game)
        end
      end

      context 'with a previous game' do

        def create_question user
          last_week_answer = create :answer, game: last_week_game
          create :question, answer: last_week_answer, user: last_week_user
        end

        let(:last_week_game) { create :game, ended_at: game.ended_at - 1.week }
        let(:last_week_user) { create :user }

        before do
          create_question last_week_user
        end

        subject { get :show, params: { game_id: game.id, season: season } }

        it 'has last weeks users' do
          subject
          expect(assigns(:results).map(&:user)).to include last_week_user
        end

        context 'user has multiple answers from last week' do
          before do
            create_question last_week_user
          end

          it 'has a user once' do
            subject
            matching_users = assigns(:results).select { |y| y.user == last_week_user }
            expect(matching_users.count).to eq 1
          end
        end

        context 'user exists in both weeks' do
          let(:last_week_user) { question.user }

          it 'has only the one result' do
            subject
            expect(assigns(:results).count).to eq 1
          end
        end
      end
    end
  end

  describe "GET money" do
    let!(:game_result) { create(:game_result, game: game) }

    it 'should assign the results to @results' do
      get :money, params: { season: season }
      expect(result).to eq(game_result.user)
    end

    it 'should respond to html' do
      get :money, params: { season: season }
      expect(response).to have_http_status(:success)
    end

    it 'should respond to json' do
      get :money, params: { season: season, format: :json }
      expect(response).to have_http_status(:success)
    end
  end
end
