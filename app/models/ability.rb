class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_role?(:admin)
      can :manage, :all
    else
      if user
        can :manage, Question, :user_id => user.id
        can :final, Answer
        cannot :check, Question
      end
      can :read, Question
      can :read, Game
      can :read, Answer
    end
  end
end
