class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_role?(:admin)
      can :manage, :all
      cannot :check, Answer do |answer|
        !answer.closed?
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
      can :show, Answer
    end
  end
end
