Rails.application.routes.draw do
  resources :projects do
    resources :actors
  end
end
