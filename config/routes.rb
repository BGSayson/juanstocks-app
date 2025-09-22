Rails.application.routes.draw do
  # devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  
  root "welcome#index"
  get "dashboard" => "dashboard#index", as: :dashboard

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  
  resources :admins, shallow: true do
    resources :users
  end

  # Extra admin paths
  get "/all_users" => "admins#all_users"
  get "/all_pending_users" => "admins#all_pending_users"
  get "/all_admins" => "admins#all_admins"
  get "/all_transactions" => "admins#all_transactions"
  get "/view_transaction/:id" => "admins#view_transaction", as: "view_transaction"
  post "/users/:id" => "users#confirm_user", as: "confirm_user"
  
  resources :wallets, shallow: true do
    resources :transactions
    resources :investments
  end


end
