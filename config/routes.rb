Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get ".well-known/acme-challenge/:id" => "web#letsencrypt"

  root "web#landing"
  get  "top" => "web#top"
  get  "privacypolicy" => "web#privacypolicy"

  get "recruit" => "api#recruit"

  post "switch"  => "debug#switch"
  get  "debug"   => "debug#debug"
  get  "create_dummy" => "debug#create_dummy"

  get  "mail_form" => "web#mail_form"
  post "send_ad_mails" => "web#send_ad_mails"

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
      get :rest
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
      get    :rest
      post   :add_college
      delete :remove_college

      get   :status,       to: "memberships#status"
      get   "status/edit", to: "memberships#status_edits"
      get   :chief,        to: "memberships#chief_edit"
      patch :chief,        to: "memberships#chief_update"
      get   :admin,        to: "memberships#admin_edit"
      patch :admin,        to: "memberships#admin_update"
      get   :editor,       to: "memberships#editor_edit"
      patch :editor,       to: "memberships#editor_update"
      get   :key,          to: "memberships#publish_key"
    end
    collection do
      get :search
      get :feed
      get :update_ranking
    end
  end
end
