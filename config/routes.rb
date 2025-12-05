Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "uploads#index"

  # Upload emails
  resources :uploads, only: [:index, :create]

  # View customers
  resources :customers, only: [:index, :show]

  # View processing logs
  resources :processing_logs, only: [:index, :show]

  # Sidekiq Web UI (optional, for monitoring)
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end

