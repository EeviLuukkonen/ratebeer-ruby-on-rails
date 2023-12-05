Rails.application.routes.draw do
  resources :users
  resources :beers
  resources :breweries
  get 'signup', to: 'users#new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'breweries#index'
  #get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'
  #post 'ratings', to: 'ratings#create'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  delete 'signout', to: 'sessions#destroy'
  resources :ratings, only: [:index, :new, :create]
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
end
