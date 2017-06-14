Rails.application.routes.draw do
  get 'auth/login', to: 'authentication#authenticate'
  resources :actors
  resources :projects do
    resources :roles
  end
  resources :role_levels
end
