Rails.application.routes.draw do
  resources :activities
  resources :students
  resources :classrooms
  resources :teachers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'
  resources :students do
    collection do
      post :import
    end
  end
end
