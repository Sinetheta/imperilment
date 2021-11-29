module Scoring
  module LeaderBoard
    def self.from_game(game)
      inject_last_weeks_users(game.build_results, game).
        map(&PlayerRow.method(:from_result))
    end

    # Generates PlayerRow with the context of the current_user.
    # The totals and order are also computed only results visible to the current user.
    # No positions are included so that no awards will be displayed.
    def self.from_my_game(game, current_user)
      (game.users | (game.prev&.users || [])).map do |user|
        points = game.all_answers.map do |answer|
          next Point.new(status: :unavailable) if answer.nil?
          this_question = answer.questions.find{ |q| q.answer == answer && q.user == user }
          your_question = answer.questions.find{ |q| q.answer == answer && q.user == current_user }
          if user == current_user
            your_point(answer, this_question)
          else
            their_point(answer, this_question, your_question)
          end
        end
        PlayerRow.new(user: user, points: points)
      end.sort_by(&:total).reverse
    end

    private

    def self.inject_last_weeks_users(game_results, game)
      return game_results unless game.prev

      game_results + (game.prev.users.uniq - game_results.map(&:user)).map do |user|
        GameResult.new(user: user,
          game: game,
          total: 0,
          position: (game_results.map(&:position).max || 1) + 1)
      end
    end

    # This is the same logic as the original GameResult#results
    def self.your_point(answer, this_question)
      if this_question.nil?
        if answer.nil?
          Point.new(answer: answer, status: :unavailable)
        else
          Point.new(answer: answer, status: :unanswered)
        end
      else
        Point.from_question(this_question)
      end
    end

    # This will show the results of marking only if your attempt has also been checked.
    # It will however tell you who has at least attempted which questions regardless of your status.
    def self.their_point(answer, this_question, your_question)
      if this_question.nil?
        Point.new(answer: answer, status: :unavailable)
      else
        if this_question.checked? && your_question&.checked?
          Point.from_question(this_question)
        else
          Point.new(answer: answer, status: :unmarked)
        end
      end
    end
  end
end
