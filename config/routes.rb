Imperilment::Application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }
  namespace :admin do
    resources :users, except: %i(new create) do
      put :grant_admin, on: :member, as: :grant
    end
  end

  resources :categories
  resources :games do
    resources :answers do
      resources :questions
      member do
        get 'final'
      end
    end
  end
  resources :web_hooks

  get 'leader_board/money' => 'leader_boards#money', as: :overall_money_leader_board
  get '/leader_board/overall' => 'leader_boards#index', as: :overall_leader_board
  get '/leader_board(/:game_id)' => 'leader_boards#show', as: :leader_board
  root to: 'landing#show'
end
