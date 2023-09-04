Rails.application.routes.draw do
  devise_for :users, controllers: { 
    sessions: 'users/sessions',
    registrations: 'users/registrations' }
  resources :activities
  resources :students
  resources :classrooms
  resources :teachers
  get 'users/search/index'
  get 'search/index'
  get 'devise/search/index'
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
