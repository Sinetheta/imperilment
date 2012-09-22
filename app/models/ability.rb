class Ability
  include CanCan::Ability

  def initialize(user)
    # FIXME
    can [:create, :read, :update, :destroy], :all
  end
end
