Rails.application.routes.draw do
  # Devise routes for the Admin model. 
  # Since :registerable is removed from the model, only sessions (login/logout) 
  # and optionally password recovery will be available.
  devise_for :admins

  # Admin Namespace: Protected routes for the dashboard
  namespace :admins do
    # This route will be accessible as admin_dashboard_path
    get 'dashboard', to: 'dashboards#index', as: 'dashboard'
  end

  # Root route for the application
  root "pages#home"
end
