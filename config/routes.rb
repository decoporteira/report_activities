Rails.application.routes.draw do
  get 'users/index'
 
  devise_for :users, :path_prefix => 'id', controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations'  }
    resources :users, :only =>[:show]
  resources :activities
  resources :students
  resources :classrooms
  resources :teachers
  resources :users
  get 'search/index'

  match '/users',   to: 'users#index',   via: 'get'
 
  
  match '/users/:id',     to: 'users#show',       via: 'get'
  # get 'devise/search/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :students do
    collection do
      post :import
    end
  end
  resources :classrooms do
    collection do
      post :create_activity
      
    end
  end
end
