Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'students#index'
  resources :students do
    collection do
      post :import
    end
  end
end
