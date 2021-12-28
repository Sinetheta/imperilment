require 'spec_helper'

describe AnswersController do
  authorize

  # Additional params sent with each request
  # Convenient for nested controllers.
  def default_params
    {
      game_id: game.to_param,
      answer: {
        category_id: category.id,
        start_date: answer.start_date + 1.day
      }
    }
  end

  let!(:answer) { create :answer }
  let(:category) { answer.category }

  let(:game) { answer.game }

  describe "GET index" do
    it "assigns all answers as @answers" do
      get :index, params: { game_id: game.to_param }
      expect(assigns(:answers)).to match_array([answer])
    end
  end

  describe "GET show" do
    render_views

    context "when it's too soon to answer the question" do
      let!(:answer) { create :answer, start_date: 5.days.from_now }

      it "renders a countdown page" do
        get :show, params: default_params.merge(id: answer.to_param)
        expect(response.body).to match /Available in 4 days/
      end
    end

    context "when answer has an amount" do
      let!(:answer) { create :answer, answer: 'this answer text' }

      it "assigns the requested answer as @answer" do
        get :show, params: default_params.merge(id: answer.to_param)
        expect(assigns(:answer)).to eq(answer)
      end

      it "renders the full answer page" do
        get :show, params: default_params.merge(id: answer.to_param)
        expect(response.body).to match /this answer text/
      end
    end

    context "when answer does not have an amount" do
      let!(:answer) { create :answer, amount: nil }

      context "when current user has a question assigned" do
        it "assigns the requested answer as @answer" do
          get :show, params: default_params.merge(id: answer.to_param)
          expect(assigns(:answer)).to eq(answer)
        end
      end

      context "when the current user does nto have a question assigned" do
        it "redirects to the final round" do
          get :show, params: default_params.merge(id: answer.to_param)
          expect(response).to redirect_to([:final, game, answer])
        end
      end
    end
  end

  describe "GET final" do
    context "when the user has an question" do
      before { allow_any_instance_of(Answer).to receive(:question_for) { build :question } }

      it "redirects to the show page" do
        get :final, params: default_params.merge(id: answer.to_param)
        expect(response).to redirect_to([game, answer])
      end
    end

    context "when the user does not have a question" do
      it "assigns @answer" do
        get :final, params: default_params.merge(id: answer.to_param)
        expect(assigns(:answer)).to eq(answer)
      end

      before { allow_any_instance_of(Game).to receive(:score) { 1000 } }

      context "when wager is valid" do
        it "creates a question" do
          get :final, params: default_params.merge(id: answer.to_param, wager: 600)
          expect(assigns(:question)).to be_a(Question)
        end
      end

      context " when wager is not valid" do
        it "flashes an error" do
          get :final, params: default_params.merge(id: answer.to_param, wager: 1600)
          expect(assigns(:question).errors[:amount]).not_to be_nil
        end
      end
    end
  end

  describe "GET new" do
    it "assigns a new answer as @answer" do
      get :new, params: { game_id: game.to_param }
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'picks the default category' do
      get :new, params: { game_id: game.to_param }
      expect(assigns(:answer).category).to eq(Category.last)
    end
  end

  describe "GET edit" do
    it "assigns the requested answer as @answer" do
      get :edit, params: default_params.merge(id: answer.to_param)
      expect(assigns(:answer)).to eq(answer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      subject { post :create, params: default_params }
      it "creates a new Answer" do
        expect {
          subject
        }.to change(Answer, :count).by(1)
      end

      it "assigns a newly created answer as @answer" do
        subject
        expect(assigns(:answer)).to be_a(Answer)
        expect(assigns(:answer)).to be_persisted
      end

      it "redirects to the created answer" do
        subject
        expect(response).to redirect_to([game, Answer.last])
      end
    end

    describe "with invalid params" do
      before(:each) do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Answer).to receive(:save).and_return(false)
        allow_any_instance_of(Answer).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create, params: default_params
      end

      it "assigns a newly created but unsaved answer as @answer" do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested answer" do
        expect_any_instance_of(Answer).to receive(:update).with("amount" => '100')
        put :update, params: default_params.merge(id: answer.to_param, answer: { "amount" => '100' })
      end

      it "assigns the requested answer as @answer" do
        put :update, params: default_params.merge(id: answer.to_param)
        expect(assigns(:answer)).to eq(answer)
      end

      it "redirects to the answer" do
        put :update, params: default_params.merge(id: answer.to_param)
        expect(response).to redirect_to([game, answer])
      end
    end

    describe "with invalid params" do
      it "assigns the answer as @answer" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Answer).to receive(:save).and_return(false)
        allow_any_instance_of(Answer).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: default_params.merge(id: answer.to_param, answer: { "amount" => "invalid value" })
        expect(assigns(:answer)).to eq(answer)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Answer).to receive(:save).and_return(false)
        allow_any_instance_of(Answer).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, params: default_params.merge(id: answer.to_param, answer: { "amount" => "invalid value" })
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested answer" do
      expect do
        delete :destroy, params: default_params.merge(id: answer.to_param)
      end.to change(Answer, :count).by(-1)
    end

    it "redirects to the answers list" do
      delete :destroy, params: default_params.merge(id: answer.to_param)
      expect(response).to redirect_to(game)
    end
  end
end
