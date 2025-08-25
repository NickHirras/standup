Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Root route
  root 'home#index'
  
  # Dashboard
  get 'dashboard', to: 'home#dashboard'

  # Admin routes
  resources :companies
  resources :users
  resources :chat_integrations do
    member do
      post :test_connection
    end
  end

  # Team routes
  resources :teams do
    member do
      get :manage_members
      post :add_member
      delete :remove_member
    end
    
    # Ceremony routes
    resources :ceremonies do
      member do
        get :participate
        post :submit_responses
        get :responses
      end
      
      # Question routes
      resources :questions do
        collection do
          post :reorder
        end
      end
    end
  end

  # Team chat configuration routes
  resources :team_chat_configs, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # User work schedule routes
  resource :work_schedule, only: [:show, :edit, :update]

  # Health check
  get 'health', to: 'health#show'
end
