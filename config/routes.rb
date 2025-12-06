Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "uploads#index"
  resources :uploads, only: [:index, :create]
  resources :customers, only: [:index, :show]
  resources :processing_logs, only: [:index, :show]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end

