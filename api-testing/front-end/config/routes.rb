Rails.application.routes.draw do
  resources :users

  resources :account_activations, only: [:edit]

  get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  delete '/logout', to: 'sessions#destroy'

  root 'users#new'
end
