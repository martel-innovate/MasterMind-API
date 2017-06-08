Rails.application.routes.draw do
  resources :projects do
    resources :actors
    resources :roles
  end
  resources :role_levels
end
