Imperilment::Application.routes.draw do
  resources :categories


  resources :games


  get "landing/show"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'landing#show'
end
