Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'home#index'
  get 'users/index'

  get 'show', to: 'users#show', as: 'current_user'
  devise_for :users
  resources :users, :only =>[:show, :edit]
  resources :attendances do
    member do 
      patch 'update_attendance'
    end
  end
  resources :users, :only =>[:show]
  resources :activities do
    member do 
      patch 'update_late'
      patch 'update_late_to_missing'

    end
  end
  
 
  resources :teachers do 
    resources :addresses, only: [:new, :create, :show, :edit, :update]
  end
  resources :users
  
  get 'search/index'
  get 'search/filter'
  match '/users',   to: 'users#index',   via: 'get'

  get 'addresses/',   to: 'addresses#index'

  resources :students do
    collection do
      get 'not_registered'
    end
    get 'activities_by_student', on: :member
    get 'report', on: :member
    resources :resumes, only: [:new, :create, :index, :show, :edit, :update]
    resources :addresses, only: [:new, :create, :show, :edit, :update]
    
    collection do
      post :import
    end
  end
  resources :financial_responsibles, only: [:new, :create, :index, :show]
  resources :classrooms do
    collection do
      post :create_activity
    end
  end
end
