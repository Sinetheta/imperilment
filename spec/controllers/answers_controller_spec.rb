require 'spec_helper'

describe AnswersController do
  authorize

  # Additional params sent with each request
  # Convenient for nested controllers.
  def default_params
    {
      game_id: game.to_param,
      answer: {
        category_id: 1,
        start_date: answer.start_date + 1.day
      }
    }
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
    context "when answer has an amount" do
      it "assigns the requested answer as @answer" do
        get :show, default_params.merge(id: answer.to_param)
        assigns(:answer).should eq(answer)
      end
    end

    context "when answer does not have an amount" do
      let!(:answer) { create :answer, amount: nil }

      context "when current user has a question assigned" do
        it "assigns the requested answer as @answer" do
          get :show, default_params.merge(id: answer.to_param)
          assigns(:answer).should eq(answer)
        end
      end

      context "when the current user does nto have a question assigned" do
        it "redirects to the final round" do
          get :show, default_params.merge(id: answer.to_param)
          response.should redirect_to([:final, game, answer])
        end
      end
    end
  end

  describe "GET final" do
    context "when the user has an question" do
      before { Answer.any_instance.stub(:question_for) { build :question } }

      it "redirects to the show page" do
        get :final, default_params.merge(id: answer.to_param)
        response.should redirect_to([game, answer])
      end
    end

    context "when the user does not have a question" do
      it "assigns @answer" do
        get :final, default_params.merge(id: answer.to_param)
        assigns(:answer).should eq(answer)
      end

      before { Game.any_instance.stub(:score) { 1000 } }

      context "when wager is valid" do
        it "creates a question" do
          get :final, default_params.merge(id: answer.to_param, wager: 600)
          assigns(:question).should be_a(Question)
        end
      end

      context" when wager is not valid" do
        it "flashes an error" do
          get :final, default_params.merge(id: answer.to_param, wager: 1600)
          assigns(:question).errors[:amount].should_not be_nil
        end
      end
    end
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      get :new, default_params
      assigns(:answer).should be_a_new(Answer)
    end

    it 'picks the default category' do
      get :new, default_params
      assigns(:answer).category.should == Category.last
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
          post :create, default_params
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
