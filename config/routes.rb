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
    end

    namespace :doctors do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
    end

    namespace :patients do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :patients
    end
  end
end
