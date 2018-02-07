Rails.application.routes.draw do
  # Namespace V2 routes (currently not used)
  namespace :v2 do
    resources :projects, only: :index
  end

  # Namespace V1 routes
  namespace :v1 do
    # Routes for data models
    resources :actors
    resources :role_levels
    resources :service_types
    resources :projects do
      resources :services
      resources :ngsi_subscriptions
      resources :roles
      resources :clusters
    end

    # Cluster routes for deploying stacks, removing stacks, getting info
    get '/projects/:project_id/clusters/:id/info', to: 'clusters#info'
    get '/projects/:project_id/clusters/:id/version', to: 'clusters#version'
    get '/projects/:project_id/clusters/:id/getstack', to: 'clusters#getStack'
    get '/projects/:project_id/clusters/:id/deploy', to: 'clusters#deploy'
    get '/projects/:project_id/clusters/:id/deploywithdockerclient', to: 'clusters#deployWithDockerClient'
    get '/projects/:project_id/clusters/:id/removestack', to: 'clusters#removeStack'

    # NGSI Subs routes for registering, deleting, toggling subs
    get '/projects/:project_id/ngsi_subscriptions/:id/register', to: 'ngsi_subscriptions#registerSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/activate', to: 'ngsi_subscriptions#activateSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/deactivate', to: 'ngsi_subscriptions#deactivateSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/remove', to: 'ngsi_subscriptions#removeSubscription'
  end

  # Login route
  get 'auth/login', to: 'authentication#authenticate'
  get 'auth/token', to: 'authentication#authenticateNoOauth'

  # Version route
  get 'version', to: 'version#version'
end
