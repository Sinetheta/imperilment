module Scoring
  # A class for holding the outcome of a single player's attempt at a clue.
  class Point
    attr_reader :answer, :value

    # Statuses are the same as GameResult
    # One of [ :correct, :incorrect, :unmarked, :unavailable, :unanswered ]
    #
    # The three Question#status which refer to an answered question's correctness.
    # :unanswered if it's available for this visitor to attempt.
    # :unavailable there is no response and we will not allow them to try.
    attr_reader :status

    def self.from_question(question)
      new(answer: question.answer, status: question.status, value: question.value)
    end

    def initialize(answer: nil, status:, value: 0)
      @answer = answer
      @status = status
      @value = value
    end
  end
end
