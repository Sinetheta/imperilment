class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_role?(:admin)
      can :manage, :all
    else
      can :read, Game
      can :read, Answer
      can :manage, Question, :user_id => user.id
    end
  end
end
