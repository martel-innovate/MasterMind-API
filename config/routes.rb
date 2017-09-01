Rails.application.routes.draw do
  namespace :v2 do
    resources :projects, only: :index
  end

  namespace :v1 do
    resources :actors
    resources :role_levels
    resources :service_types
    resources :clusters
    resources :projects do
      resources :services
      resources :roles
      resources :clusters
    end
    get '/projects/:project_id/clusters/:id/info', to: 'clusters#info'
    get '/projects/:project_id/clusters/:id/version', to: 'clusters#version'
    post '/projects/:project_id/clusters/:id/deploy', to: 'clusters#deploy'
  end

  get 'auth/login', to: 'authentication#authenticate'
end
