require 'sidekiq/web'
Rails
  .application
  .routes
  .draw do
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
    mount Sidekiq::Web => '/sidekiq'
    root to: 'home#index'
    get 'users/index'

    get 'show', to: 'users#show', as: 'current_user'
    devise_for :users
    resources :users, only: %i[show edit]
    resources :attendances do
      member { patch 'update_attendance' }
    end
    resources :users, only: [:show]
    resources :activities do
      member do
        patch 'update_late'
        patch 'update_late_to_missing'
      end
    end

    resources :teachers do
      resources :addresses, only: %i[new create show edit update]
    end
    resources :users

    get 'search/index'
    get 'search/filter'
    match '/users', to: 'users#index', via: 'get'

    get 'addresses/', to: 'addresses#index'

    get 'monthly_fees/', to: 'monthly_fees#all'
    get 'monthly_fees/not_paid', to: 'monthly_fees#not_paid'
    patch 'update_paid', to: 'monthly_fees#update_paid'

    resources :students do
      collection do
        get 'incomplete'
        get 'not_registered'
      end
      get 'activities_by_student', on: :member
      get 'report', on: :member
      resources :resumes, only: %i[new create index show edit update destroy]
      resources :addresses, only: %i[new create show edit update]
      resources :monthly_fees,
                only: %i[index show new create edit update destroy] do
        collection { post :create_anual_fees }
      end
      collection { post :import }
    end
    post "/monthly_fees" => "monthly_fees#create_all_anual_fees", :as => :create_all_anual_fees
    resources :plans, only: %i[new create index show edit update destroy]
    resources :current_plans,
              only: %i[new create index show edit update destroy]
    resources :financial_responsibles,
              only: %i[new create index show edit update]
    resources :classrooms do
      collection { post :create_activity }
      post :update_current_plan, on: :member
    end
    resources :responsibles, only: %i[new create show destroy]
    get 'admin_home', to: 'admin_home#index'
    get 'teacher_home', to: 'teacher_home#index'
    get 'accounting_home', to: 'accounting_home#index'
  end
