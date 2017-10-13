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
      resources :ngsi_subscriptions
      resources :roles
      resources :clusters
    end

    get '/projects/:project_id/clusters/:id/info', to: 'clusters#info'
    get '/projects/:project_id/clusters/:id/version', to: 'clusters#version'
    get '/projects/:project_id/clusters/:id/getstack', to: 'clusters#getStack'
    get '/projects/:project_id/clusters/:id/deploy', to: 'clusters#deploy'
    get '/projects/:project_id/clusters/:id/deploywithdockerclient', to: 'clusters#deployWithDockerClient'

    get '/projects/:project_id/ngsi_subscriptions/:id/register', to: 'ngsi_subscriptions#registerSubscriptionToBroker'
  end

  get 'auth/login', to: 'authentication#authenticate'
end
