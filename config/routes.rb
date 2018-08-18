Rails.application.routes.draw do
  resources :contacts
  root to: 'users#index'
  resources :organizations
  devise_for :users
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
