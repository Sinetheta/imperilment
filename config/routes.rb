Imperilment::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
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

  # Since the in_office parameter will only match `in_office`, it
  #   acts as a optional URL modifier. I.e., '/leader_board/in_office/'
  #   will use the same controller as '/leader_board/', but the first
  #   one will have params[:in_office] set, which is used to filter
  #   out people who are not in office.
  # NOTE: game_id has to match a number because otherwise it would
  #   be set to 'in_office'.
  get 'leader_board/money(/:in_office)' => 'leader_boards#money',
    as: :overall_money_leader_board,
    constraints: { in_office: /in_office/ }
  get '/leader_board/overall(/:in_office)' => 'leader_boards#index',
    as: :overall_leader_board,
    constraints: { in_office: /in_office/ }
  get '/leader_board(/:game_id)(/:in_office)' => 'leader_boards#show',
    as: :leader_board,
    constraints: { in_office: /in_office/, game_id: /[0-9]+/ }
  root to: 'landing#show'
end
