Rails.application.routes.draw do
  namespace :v2 do
    resources :projects, only: :index
  end

  namespace :v1 do
    resources :actors
    resources :role_levels
    resources :service_types
    resources :projects do
      resources :roles
      resources :clusters
    end
    get '/projects/:project_id/clusters/:id/info', to: 'clusters#info'
    get '/projects/:project_id/clusters/:id/version', to: 'clusters#version'
    get '/projects/:project_id/clusters/:id/testcompose', to: 'clusters#testcompose'
  end

  get 'auth/login', to: 'authentication#authenticate'
  get 'test/test', to: 'dockerswarm#test'
end
