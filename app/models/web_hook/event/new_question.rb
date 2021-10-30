# A payload to describe a respondant
module WebHook::Event
  class NewQuestion
    def initialize(question)
      @question = question
    end

    def serialize
      as_json.to_json
    end

    def as_json
      @question.as_json(only: [:id, :created_at, :updated_at])
        .tap do |h|
          h['answer'] = answer_json
          h['user'] = respondant_email
        end
    end

    # The clue which inspired this respondant.
    def answer_json
      NewAnswer.new(@question.answer).as_json
    end

    def respondant_email
      @question.user.email
    end
  end
end
