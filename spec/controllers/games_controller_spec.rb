require 'spec_helper'

describe GamesController do
  authorize

  let!(:game) { create :game }
  let(:default_params) { { game: { foo: 'bar' } } }

  describe "GET index" do
    it "assigns all games as @games" do
      get :index
      expect(assigns(:games)).to eq([game])
    end
  end

  describe "GET show" do
    it "assigns the requested game as @game" do
      get :show, params: { id: game.to_param }
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "GET new" do
    it "assigns a new game as @game" do
      get :new
      expect(assigns(:game)).to be_a_new(Game)
    end
  end

  describe "GET edit" do
    it "assigns the requested game as @game" do
      get :edit, params: { id: game.to_param }
      expect(assigns(:game)).to eq(game)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Game" do
        expect do
          post :create
        end.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create
        expect(assigns(:game)).to be_a(Game)
        expect(assigns(:game)).to be_persisted
      end

      it "redirects to the created game" do
        post :create
        expect(response).to redirect_to(Game.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Game).to receive(:save).and_return(false)
        allow_any_instance_of(Game).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create
        expect(assigns(:game)).to be_a_new(Game)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Game).to receive(:save).and_return(false)
        allow_any_instance_of(Game).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested game" do
        expect_any_instance_of(Game).to receive(:update).with("ended_at" => "2012-12-27 15:58:08")
        put :update, params: { id: game.to_param, game: { "ended_at" => "2012-12-27 15:58:08" } }
      end

      it "assigns the requested game as @game" do
        put :update, params: { id: game.to_param, game: { "ended_at" => "2012-12-27 15:58:08" } }
        expect(assigns(:game)).to eq(game)
      end

      it "redirects to the game" do
        put :update, params: { id: game.to_param, game: { "ended_at" => "2012-12-27 15:58:08" } }
        expect(response).to redirect_to(game)
      end
    end

    describe "with invalid params" do
      it "assigns the game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Game).to receive(:save).and_return(false)
        allow_any_instance_of(Game).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: { id: game.to_param, game: { "ended_at" => "invalid value" } }
        expect(assigns(:game)).to eq(game)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Game).to receive(:save).and_return(false)
        allow_any_instance_of(Game).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: { id: game.to_param, game: { "ended_at" => "invalid value" } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested game" do
      expect do
        delete :destroy, params: { id: game.to_param }
      end.to change(Game, :count).by(-1)
    end

    it "redirects to the games list" do
      delete :destroy, params: { id: game.to_param }
      expect(response).to redirect_to(games_url)
    end
  end
end
