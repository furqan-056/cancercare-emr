Rails.application.routes.draw do
  devise_for :users
  root "pages#home"

  constraints AdminSubdomainConstraint do
    devise_for :admins

    namespace :admins do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :organizations
      resources :users
    end
  end

  constraints OrganizationSubdomainConstraint do
    namespace :managers do
      get 'dashboard', to: 'dashboards#index', as: 'dashboard'
      resources :doctors
    end
  end
end
