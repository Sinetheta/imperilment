require 'spec_helper'

describe GamesController do
  authorize

  let!(:game) { create :game }
  let(:default_params) { { game: {foo: 'bar'} } }

  describe "GET index" do
    it "assigns all games as @games" do
      get :index
      assigns(:games).should eq([game])
    end
  end

  describe "GET show" do
    it "assigns the requested game as @game" do
      get :show, id: game.to_param
      assigns(:game).should eq(game)
    end
  end

  describe "GET new" do
    it "assigns a new game as @game" do
      get :new
      assigns(:game).should be_a_new(Game)
    end
  end

  describe "GET edit" do
    it "assigns the requested game as @game" do
      get :edit, id: game.to_param
      assigns(:game).should eq(game)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Game" do
        expect {
          post :create, default_params
        }.to change(Game, :count).by(1)
      end

      it "assigns a newly created game as @game" do
        post :create, default_params
        assigns(:game).should be_a(Game)
        assigns(:game).should be_persisted
      end

      it "redirects to the created game" do
        post :create, default_params
        response.should redirect_to(Game.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        Game.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        assigns(:game).should be_a_new(Game)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        Game.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested game" do
        Game.any_instance.should_receive(:update_attributes).with({ "ended_at" => "2012-12-27 15:58:08" })
        put :update, id: game.to_param, game: { "ended_at" => "2012-12-27 15:58:08" }
      end

      it "assigns the requested game as @game" do
        put :update, id: game.to_param, game: {"ended_at" => "2012-12-27 15:58:08"}
        assigns(:game).should eq(game)
      end

      it "redirects to the game" do
        put :update, id: game.to_param, game: {"ended_at" => "2012-12-27 15:58:08"}
        response.should redirect_to(game)
      end
    end

    describe "with invalid params" do
      it "assigns the game as @game" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        Game.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: game.to_param, game: { "ended_at" => "invalid value" }
        assigns(:game).should eq(game)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Game.any_instance.stub(:save).and_return(false)
        Game.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, id: game.to_param, game: { "ended_at" => "invalid value" }
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested game" do
      expect {
        delete :destroy, id: game.to_param
      }.to change(Game, :count).by(-1)
    end

    it "redirects to the games list" do
      delete :destroy, id: game.to_param
      response.should redirect_to(games_url)
    end
  end

end
