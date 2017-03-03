Rails.application.routes.draw do

  root 'web#top'
  get  'signups' => 'web#signups'
  get  "privacypolicy" => "web#privacypolicy"

  devise_for :users, controllers: {
    sessions:           'users/sessions',
    registrations:      'users/registrations',
    confirmations:      'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks',
  }

  resources :users do
    member do
      get :following, :followers
      get :favorites
      get :foots
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :messages, path: "message"
  resources :message_rooms, only: [:index, :new, :show], path: "messages"

  resources :notifications

  get "blogs"  => "blogs#indexes"
  get "events" => "events#indexes"

  get "entry/:key" => "web#circle_key"

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

      get    :status, to: "memberships#status_edits"
      get    :admin,  to: "memberships#admin_edit"
      patch  :admin,  to: "memberships#admin_update"
      get    :key,    to: "memberships#publish_key"
    end
    collection do
      get :search
      get :feed
    end
  end
end
