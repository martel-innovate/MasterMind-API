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

    # Routes for registering roles
    get '/projects/:project_id/getactorbyrole', to: 'roles#getProjectActorByRole'
    get '/projects/:project_id/registerfullname', to: 'roles#registerRoleByFullname'

    # Cluster routes for deploying stacks, removing stacks, getting info
    get '/projects/:project_id/clusters/:id/getstack', to: 'clusters#getStack'
    get '/projects/:project_id/clusters/:id/getnetworks', to: 'clusters#getNetworks'
    get '/projects/:project_id/clusters/:id/getvolumes', to: 'clusters#getVolumes'
    post '/projects/:project_id/clusters/:id/createnetwork', to: 'clusters#createNetwork'
    post '/projects/:project_id/clusters/:id/createvolume', to: 'clusters#createVolume'
    get '/projects/:project_id/clusters/:id/deploy', to: 'clusters#deploy'
    get '/projects/:project_id/clusters/:id/removestack', to: 'clusters#removeStack'

    # NGSI Subs routes for registering, deleting, toggling subs
    get '/projects/:project_id/ngsi_subscriptions/:id/register', to: 'ngsi_subscriptions#registerSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/activate', to: 'ngsi_subscriptions#activateSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/deactivate', to: 'ngsi_subscriptions#deactivateSubscription'
    get '/projects/:project_id/ngsi_subscriptions/:id/remove', to: 'ngsi_subscriptions#removeSubscription'

    # Routes for dealing with securing services
    post '/projects/:project_id/services/secureservice', to: 'services#secure_service'

  end

  # Login route
  get 'auth/login', to: 'authentication#authenticate'
  get 'auth/inspect', to: 'authentication#inspectToken'
  get 'auth/token', to: 'authentication#authenticateNoOauth'

  # Version route
  get 'version', to: 'version#version'
end
