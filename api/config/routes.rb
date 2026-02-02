Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show"

  namespace :api do
    # Authentication
    scope :auth do
      post 'signup', to: 'auth#signup'
      post 'login', to: 'auth#login'
      post 'logout', to: 'auth#logout'
      get  'verify', to: 'auth#verify_token'
      post 'forgot-password', to: 'auth#forgot_password'
      get  'verify-reset-token', to: 'auth#verify_reset_token'
      post 'reset-password', to: 'auth#reset_password'
    end

    # User appointments
    resources :appointments, only: [:index, :create, :show, :update, :destroy]

    # Users
    resources :users, only: [:create, :index]

    # Admin
    namespace :admin do
      get 'dashboard', to: 'admin#dashboard'

      # Users
      get 'users', to: 'admin#users'
      get 'users/:id', to: 'admin#user_details'
      delete 'users/:id', to: 'admin#delete_user'
      patch 'users/:id/promote', to: 'admin#promote_user'
      patch 'users/:id/demote', to: 'admin#demote_user'

      # Appointments
      get 'appointments', to: 'admin#all_appointments'
      delete 'appointments/:id', to: 'admin#delete_appointment'
    end
  end
end
