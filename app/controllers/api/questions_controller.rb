module Api
  class QuestionsController < BaseController
    load_resource :game
    load_resource :answer, through: :game
    load_resource :question, through: :answer

    def show
      render json: @question, root: false
    end

    def update
      @question.update(question_params)
      render json: @question, root: false
    end
  end
end
