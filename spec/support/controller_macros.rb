module ControllerMacros
  def login
    before(:each) do
      unless user.nil?
        @request.env["devise.mapping"] = Devise.mappings[:user]
        allow(@controller).to receive(:current_user).and_return(user)
        sign_in user
      end
    end
  end

  def logout
    before(:each) do
      unless user.nil?
        @controller.stub(:current_user).and_return(nil)
        sign_out user
      end
    end
  end

  # Controllers don't need to concern themselves with authorization
  # since we test that all seperately.
  def authorize
    before(:each) do
      @ability = Object.new.tap { |o| o.extend CanCan::Ability }
      @ability.can :manage, :all
      allow(@controller).to receive(:current_ability) { @ability }
    end
  end

  def authorize_and_login
    authorize
    login
  end
end
