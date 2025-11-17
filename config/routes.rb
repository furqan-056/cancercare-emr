Rails.application.routes.draw do
  devise_for :admins

  namespace :admins do
    get 'dashboard', to: 'dashboards#index', as: 'dashboard'
  end

  root "pages#home"
end
