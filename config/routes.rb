Rails.application.routes.draw do
  resources :memberships do
    post 'confirm_application', on: :member
  end
  resources :beer_clubs
  resources :users do 
    post 'toggle_activity', on: :member
  end
  resources :beers
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  get 'signup', to: 'users#new'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'breweries#index'
  #get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new'
  #post 'ratings', to: 'ratings#create'
  get 'signin', to: 'sessions#new'
  #get 'places', to: 'places#index'
  post 'places', to: 'places#search'
  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'
  delete 'signout', to: 'sessions#destroy'
  resources :ratings, only: [:index, :new, :create]
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
end
