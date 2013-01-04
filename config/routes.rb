Imperilment::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :categories
  resources :games do
    resources :answers do
      resources :questions
    end
  end

  root :to => 'landing#show'
end
