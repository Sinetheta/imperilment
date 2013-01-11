Imperilment::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :categories
  resources :games do
    resources :answers do
      resources :questions
      member do
        get 'final'
      end
    end
  end

  match '/leader_board/overall' => 'leader_boards#index', as: :overall_leader_board
  match '/leader_board(/:game_id)' => 'leader_boards#show', as: :leader_board

  root :to => 'landing#show'
end
