module LeaderBoardHelper
  def rank_class(rank)
    case rank
    when 0
      "gold"
    when 1
      "silver"
    when 2
      "bronze"
    else
      ""
    end
  end

  def breakdown_icon(game, user, date)
    answer = game.answers.reject{|a| a.start_date != date}.first
    return '' if answer.nil?

    question = answer.question_for(user)
    return icon 'asterisk' if question.nil?

    case question.correct
    when true
      return icon 'ok'
    when false
      return icon 'remove'
    else
      return icon 'minus'
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
