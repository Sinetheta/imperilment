class GameResult < ActiveRecord::Base
  belongs_to :user
  belongs_to :game

  def self.all_results
    select_results_by_user.order('first desc, second desc, third desc, total desc').to_a
  end

  def self.all_results_by_money
    select_results_by_user.order('total desc, first desc, second desc, third desc').to_a
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
    game.date_range.map do |date|
      game.answers.detect{|a| a.start_date == date}
    end
  end

  def self.select_results_by_user
    self.select('user_id, sum(total) as total,
                      SUM(CASE WHEN position = 1 THEN 1 ELSE 0 END) as first,
                      SUM(CASE WHEN position = 2 THEN 1 ELSE 0 END) as second,
                      SUM(CASE WHEN position = 3 THEN 1 ELSE 0 END) as third'
                     )
      .where('total > 0')
      .group(:user_id)
  end

  def percentage_correct
    correct = results.count(:correct)
    incorrect = results.count(:incorrect)
    correct.to_f / (correct + incorrect).to_f * 100
  end
end
