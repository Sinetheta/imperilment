class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_role?(:admin)
      can :manage, :all
      # Cannot check Answer when user hasn't supplied their question
      cannot :check, Answer do |answer|
        !answer.closed? || !answer.question_for(user)
      end
      can :correct, Question
    else
      if user
        can :manage, Question do |question|
          if question.user_id
            next false unless question.user_id == user.id
          end
          !question.answer.too_soon?
        end
        can :final, Answer
        cannot :check, Answer
      end
      can :index, Question
      can :show, Question do |question|
        question.answer.closed?
      end
      can :read, Game
      can :read, Answer
    end
  end
end
