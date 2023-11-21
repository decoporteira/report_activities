Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'users/index'
 # match '/users/:id',     to: 'users#show',       via: 'get'
  get 'show', to: 'users#show', as: 'current_user'
  devise_for :users
  resources :users, :only =>[:show, :edit]

  resources :users, :only =>[:show]
  resources :activities do
    member do 
      patch 'update_late'
      patch 'update_late_to_missing'
      
    end
  end
  resources :students
  resources :classrooms
  resources :teachers
  resources :users
  
  get 'search/index'
  
  match '/users',   to: 'users#index',   via: 'get'
  

  # get 'devise/search/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :students do
    resources :resumes, only: [:new, :create, :index, :show, :edit, :update]
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
