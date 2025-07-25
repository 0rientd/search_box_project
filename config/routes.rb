Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :search_queries

  get "trending" => "search_queries#trending", as: :trending_search_queries
  get "analytics" => "search_queries#analytics", as: :analytics_search_queries
  get "top_searches" => "search_queries#top_searches", as: :top_search_queries

  # Defines the root path route ("/")
  root "search_queries#index"
end
