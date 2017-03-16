Rails.application.routes.draw do
  resources :users, only: [:new, :show]

  root 'users#new'
end
