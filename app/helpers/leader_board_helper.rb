module LeaderBoardHelper
  def rank_class(rank)
    case rank
    when 1
      "gold"
    when 2
      "silver"
    when 3
      "bronze"
    else
      ""
    end
  end

  def breakdown_icon(result)
    case result
    when :unavailable
      ''
    when :unanswered
      icon 'asterisk'
    when :unmarked
      icon 'minus'
    when :correct
      icon 'check'
    when :incorrect
      icon 'times'
    end
  end

  def status_for(answer)
    if !answer
      :unavailable
    elsif !(question = answer.question_for(current_user))
      :unanswered
    else
      question.status
    end
  end


  def breakdown_link(game, date)
    answer = game.answers.reject{|a| a.start_date != date}.first
    if answer.nil?
      'javascript:;'
    else
      game_answer_path(game, answer)
    end
  end
end
