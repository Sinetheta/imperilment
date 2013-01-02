require 'spec_helper'

describe AnswersController do
  authorize

  # Additional params sent with each request
  # Convenient for nested controllers.
  def default_params
    {game_id: game.to_param}
  end

  let!(:answer) { create :answer }

  let(:game) { answer.game }

  describe "GET index" do
    it "assigns all answers as @answers" do
      get :index, default_params
      assigns(:answers).should =~ [answer]
    end
  end

  describe "GET show" do
    it "assigns the requested answer as @answer" do
      get :show, default_params.merge(id: answer.to_param)
      assigns(:answer).should eq(answer)
    end
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      get :new, default_params
      assigns(:answer).should be_a_new(Answer)
    end
  end

  describe "GET edit" do
    it "assigns the requested answer as @answer" do
      get :edit, default_params.merge(id: answer.to_param)
      assigns(:answer).should eq(answer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Answer" do
        expect {
          post :create, default_params.merge(answer: {})
        }.to change(Answer, :count).by(1)
      end

      it "assigns a newly created answer as @answer" do
        post :create, default_params
        assigns(:answer).should be_a(Answer)
        assigns(:answer).should be_persisted
      end

      it "redirects to the created answer" do
        post :create, default_params
        response.should redirect_to([game, Answer.last])
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved answer as @answer" do
        # Trigger the behavior that occurs when invalid params are submitted
        Answer.any_instance.stub(:save).and_return(false)
        Answer.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        assigns(:answer).should be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Answer.any_instance.stub(:save).and_return(false)
        Answer.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested answer" do
        Answer.any_instance.should_receive(:update_attributes).with({ "amount" => '100' })
        put :update, default_params.merge(id: answer.to_param, answer: { "amount" => '100' })
      end

      it "assigns the requested answer as @answer" do
        put :update, default_params.merge(id: answer.to_param)
        assigns(:answer).should eq(answer)
      end

      it "redirects to the answer" do
        put :update, default_params.merge(id: answer.to_param)
        response.should redirect_to([game, answer])
      end
    end

    describe "with invalid params" do
      it "assigns the answer as @answer" do
        # Trigger the behavior that occurs when invalid params are submitted
        Answer.any_instance.stub(:save).and_return(false)
        Answer.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, default_params.merge(id: answer.to_param, answer: { "amount" => "invalid value" })
        assigns(:answer).should eq(answer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Answer.any_instance.stub(:save).and_return(false)
        Answer.any_instance.stub(:errors).and_return(double(:errors, empty?: false))
        put :update, default_params.merge(id: answer.to_param, answer: { "amount" => "invalid value" })
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested answer" do
      expect {
        delete :destroy, default_params.merge(id: answer.to_param)
      }.to change(Answer, :count).by(-1)
    end

    it "redirects to the answers list" do
      delete :destroy, default_params.merge(id: answer.to_param)
      response.should redirect_to(game)
    end
  end

end
