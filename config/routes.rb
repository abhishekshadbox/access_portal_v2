Rails.application.routes.draw do
  get "posts/index"
  get "posts/new"
  get "posts/create"
  get "posts/show"

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  resources :organizations, only: [:index, :new, :create, :show] do
    member do
      get :verify
      post :subscribe
      get :verify_requests
      post :verify_user
      get :analytics
    end
    resources :posts, only: [:index, :new, :create, :show]
  end
  get "posts/allposts", to: "posts#all_posts", as: "all_posts"

end
