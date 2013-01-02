class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.has_role?(:admin)
      can [:create, :read, :update, :destroy], :all
    else
      # FIXME -- add normal permissions.
    end
  end
end
