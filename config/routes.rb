Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post :login, to: "session#create"

      resource :user, only: %I[show], controller: :user do
        resources :wallets, only: %I[index show create update destroy]
        resources :transactions, only: %I[index show create update]
      end

      resources :teams do
        resources :members, only: %I[index destroy], controller: "teams/memberships"
        resource :wallet, only: %I[show], controller: "teams/wallets"
        resources :transactions, only: %I[index show create update]

        resources :invitations, only: %i[index create destroy] do
          collection do
            get :accept, to: "invitations#accept"
          end
        end
      end
    end
  end
end
