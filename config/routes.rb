Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "habits#index"

  resources :habits do
    collection do
      get :all_habits
      get :show_habits
      post :create_habits
      patch :update_habits
    end
  end

  resources :habit_checkins, only: [:index] do
    collection do
      post :create_habit_checkins
    end
  end
end
