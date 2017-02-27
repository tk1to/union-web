Rails.application.routes.draw do

  root 'web#top'
  get  'signups' => 'web#signups'
  get  "privacypolicy" => "web#privacypolicy"

  devise_for :users, controllers: {
    sessions:      'users/sessions',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }
  # devise_scope :user do
  #   delete :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  # end

  resources :users do
    member do
      get :following, :followers
      get :favorites
      get :foots
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :messages
  resources :message_rooms, only: [:index, :new, :show]

  # resources :account_activations, only: [:edit]

  get  "blogs"   => "blogs#indexes"
  get  "events"  => "events#indexes"

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
      get    :favorited
      get    :members
      delete :resign
    end
    collection do
      get :search
      get :feed
    end
  end
end
