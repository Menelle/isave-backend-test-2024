Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace "api" do
    namespace "v1", defaults: { format: :json } do
      resources :portfolios, only: %i(index) do
        collection do
          get "risk(/:id)", to: "portfolios/risks#index", as: :risk_api_v1_portfolio
          get "break(/:id)", to: "portfolios/breaks#index", as: :break_api_v1_portfolio
        end
        member do
          post "deposit"
          post "withdrawal"
          post "transfer"
        end
      end
    end
  end
end