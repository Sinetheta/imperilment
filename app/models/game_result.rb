class GameResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def self.all_results
    select_results_by_user.reorder('first desc, second desc, third desc, total desc').to_a
  end

  def self.all_results_by_money
    select_results_by_user.reorder('total desc, first desc, second desc, third desc').to_a
  end

  def results
    answers.map do |answer|
      if !answer
        :unavailable
      elsif !(question = answer.question_for(user))
        :unanswered
      else
        question.status
      end
    end
  end

  def answers
    game.all_answers
  end

  def self.select_results_by_user
    User.joins(:game_results)
        .merge(all)
        .select('users.*,
                 sum(total) as total,
                 SUM(CASE WHEN position = 1 THEN 1 ELSE 0 END) as first,
                 SUM(CASE WHEN position = 2 THEN 1 ELSE 0 END) as second,
                 SUM(CASE WHEN position = 3 THEN 1 ELSE 0 END) as third'
                     )
      .where('total > 0')
      .group('users.id')
  end

  def percentage_correct
    correct = results.count(:correct)
    incorrect = results.count(:incorrect)
    return 0 if correct.zero? # Avoid NaN
    correct.to_f / (correct + incorrect).to_f * 100
  end
end
