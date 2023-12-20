Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'home#index'
  get 'users/index'

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
  
  resources :classrooms
  resources :teachers do 
    get 'info', on: :member
    resources :addresses, only: [:new, :create, :show, :edit, :update]
  end
  resources :users
  
  get 'search/index'
  match '/users',   to: 'users#index',   via: 'get'

  get 'addresses/',   to: 'addresses#index'

  resources :students do
    collection do
      get 'not_registered'
    end
    get 'info', on: :member
    resources :resumes, only: [:new, :create, :index, :show, :edit, :update]
    resources :addresses, only: [:new, :create, :show, :edit, :update]
    
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
