Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  constraints AdminSubdomainConstraint do
    devise_for :admins

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
      get 'appointments', to: 'resources#index', as: :appointments
      resources :appointments
      resources :slots
    end

    namespace :doctors do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
      resources :appointments
    end

    namespace :patients do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
    end
  end

  match "*path", to: redirect("/404.html"), via: :all, constraints: lambda { |req|
    !req.path.starts_with?("/rails/active_storage")
  }
end
