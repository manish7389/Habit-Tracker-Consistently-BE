require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # root "habits#all_habits"

  resources :users do
    collection do
      post :signup
      post :login
      post :forgot_password
      post :resend_code
      post :verify_reset_code
      post :reset_password
    end
  end

  resources :habits do
    collection do
      get :all_habits
      get :show_habit
      post :create_habit
      patch :update_habit
      delete :delete_habit
    end
  end

  resources :habit_checkins do
    collection do
      get :all_habit_checkins
      post :create_habit_checkins
    end
  end
end
