Rails.application.routes.draw do

  root 'web#top'
  get  'signups' => 'web#signups'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
      get :favorites
    end
  end
  resources :relationships, only: [:create, :destroy]

  resources :account_activations, only: [:edit]

  resources :circles do
    resources :blogs
    resources :events
    resources :contacts
    resources :favorites, only: [:create, :destroy]
    resources :entries, only: [:index, :create, :destroy] do
      member do
        post :accept
      end
    end
    member do
      get :favorited
    end
    collection do
      get :search
    end
  end
end
