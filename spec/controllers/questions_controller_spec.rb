require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe QuestionsController do
  authorize_and_login

  # Additional params sent with each request
  # Convenient for nested controllers.
  def default_params
    {game_id: question.answer.game, answer_id: question.answer, question: { foo: 'bar' }}
  end

  let!(:question) { create :question }

  let(:answer) { question.answer }
  let(:game) { answer.game }
  let(:user) { create :admin }

  describe "GET index" do
    context 'when the user is not an admin' do
      let(:user) { create :user }

      context 'when the user does not have a checked question' do
        it "assigns an empty list to @questions" do
          get :index, default_params
          expect(assigns(:questions)).to match_array(Question.none)
        end
      end

      context 'when the user has a checked question' do
        before(:each) do
          question.user = user
          question.correct = true
          question.save!
        end

        it "assigns an empty list to @questions" do
          get :index, default_params
          expect(assigns(:questions)).to match_array([question])
        end
      end
    end

    it "assigns all questions as @questions" do
      get :index, default_params
      expect(assigns(:questions)).to match_array([question])
    end
  end

  describe "GET show" do
    it "assigns the requested question as @question" do
      get :show, default_params.merge(id: question.to_param)
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      allow(controller).to receive(:current_user) { build_stubbed :user }
      get :new, default_params
      expect(assigns(:question)).to be_a_new(Question)
    end
  end

  describe "GET edit" do
    it "assigns the requested question as @question" do get :edit, default_params.merge(id: question.to_param)
      expect(assigns(:question)).to eq(question)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Question" do
        expect {
          post :create, default_params
        }.to change(Question, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        post :create, default_params
        expect(assigns(:question)).to be_a(Question)
      end

      it 'persists the newly created question' do
        post :create, default_params
        expect(assigns(:question)).to be_persisted
      end

      it "redirects to the created question" do
        post :create, default_params
        expect(response).to redirect_to root_path
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Question).to receive(:save).and_return(false)
        allow_any_instance_of(Question).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Question).to receive(:save).and_return(false)
        allow_any_instance_of(Question).to receive(:errors).and_return(double(:errors, empty?: false))
        post :create, default_params
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested question" do
        expect_any_instance_of(Question).to receive(:update_attributes).with({ "response" => "" })
        put :update, default_params.merge(id: question.to_param, question: { "response" => "" })
      end

      it "assigns the requested question as @question" do
        put :update, default_params.merge(id: question.to_param)
        expect(assigns(:question)).to eq(question)
      end

      it "redirects to the question" do
        put :update, default_params.merge(id: question.to_param)
        expect(response).to redirect_to root_path
      end

      describe 'updating correct' do
        subject { assigns(:question).correct }
        context 'when user is an admin' do
          before do
            put :update, {id: question.to_param, game_id: question.answer.game, answer_id: question.answer, question: { correct: true }}
          end
          it { is_expected.to be_truthy }
        end

        context 'when user is not an admin' do
          before do
            @ability.cannot :correct, Question
            put :update, {id: question.to_param, game_id: question.answer.game, answer_id: question.answer, question: { correct: true }}
          end
          it { is_expected.to be_nil }
        end
      end

    end

    describe "with invalid params" do
      it "assigns the question as @question" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Question).to receive(:save).and_return(false)
        allow_any_instance_of(Question).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, default_params.merge(id: question.to_param)
        expect(assigns(:question)).to eq(question)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Question).to receive(:save).and_return(false)
        allow_any_instance_of(Question).to receive(:errors).and_return(double(:errors, empty?: false))
        put :update, default_params.merge(id: question.to_param)
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested question" do
      expect {
        delete :destroy, default_params.merge(id: question.to_param)
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      delete :destroy, default_params.merge(id: question.to_param)
      expect(response).to redirect_to [game, answer]
    end
  end

end
