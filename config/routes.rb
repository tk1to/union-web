Rails.application.routes.draw do

  root 'web#top'
  get  'signups' => 'web#signups'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :circles do
    resources :blogs
    resources :events
    resources :contacts
  end
end
