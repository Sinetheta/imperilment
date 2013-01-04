Imperilment::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :categories
  resources :games do
    match '/leader_board' => 'leader_boards#index', as: :leader_board
    resources :answers do
      resources :questions
      member do
        get 'final'
      end
    end
  end

  root :to => 'landing#show'
end
