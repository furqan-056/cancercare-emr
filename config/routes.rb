require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  constraints AdminSubdomainConstraint do
    devise_for :admins

    authenticate :admin do
      mount Sidekiq::Web => '/admin/background-jobs'
    end

    namespace :admins do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :organizations
      resources :users
      resources :doctors
      resources :patients
    end
  end

  constraints OrganizationSubdomainConstraint do
    namespace :managers do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :doctors
      resources :patients
      resources :slots
      resources :slot_exceptions
    end

    namespace :doctors do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
      resources :slots
      resources :slot_exceptions
      resources :appointments
    end

    namespace :patients do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
      resources :doctors, only: [:index, :show] do
        resources :appointments, only: [:new, :create, :edit, :update] do
          collection do
            get :available_slots
          end
        end
    end

    resources :appointments, only: [:index, :destroy]
    end
  end

  match "*path", to: redirect("/404.html"), via: :all, constraints: lambda { |req|
    !req.path.starts_with?("/rails/active_storage")
  }
end
