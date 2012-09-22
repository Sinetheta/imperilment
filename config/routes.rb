Adjutant::Application.routes.draw do
  get "landing/show"

  devise_for :users

  root :to => 'landing#show'
end
