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
      icon 'ok'
    when :incorrect
      icon 'cancel'
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
end
