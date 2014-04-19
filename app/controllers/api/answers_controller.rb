module Api
  class AnswersController < BaseController
    load_resource :game
    load_resource :answer, through: :game

    def index
      render json: @answers, root: false, each_serializer: AnswerSerializer
    end

    def show
      render json: @answer, root: false
    end
  end
end

