Rails.application.routes.draw do

  root 'web#top'
  get  'signups' => 'web#signups'

  get    'login'  => 'sessions#new'
  post   'login'  => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
end
