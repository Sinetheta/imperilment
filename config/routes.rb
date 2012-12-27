Adjutant::Application.routes.draw do
  get "landing/show"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'landing#show'
end
