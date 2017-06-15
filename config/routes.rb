Rails.application.routes.draw do
  namespace :v2 do
    resources :projects, only: :index
  end

  namespace :v1 do
    resources :actors
    resources :role_levels
    resources :projects do
      resources :roles
    end
  end

  get 'auth/login', to: 'authentication#authenticate'
end
