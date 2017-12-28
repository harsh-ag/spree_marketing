Spree::Core::Engine.routes.draw do
  # Add your extension routes here

  namespace :admin do
    resources :contacts do
      collection do
        post 'import'
        get 'export'
      end
    end
    resources :email_lists do
      member do
        post :refresh
      end
    end
    resources :email_campaigns do
      member do
        get :send_now
      end
      collection do
        post :sync
      end
    end
    resource :email_configurations
  end

  resources :news_letter_lists, only: [] do
    collection do
      post :subscribe
      get :unsubscribe
      get :unsubscribe_action
    end
  end

  resources :out_of_stock_lists, only: [] do
    collection do
      post :subscribe
    end
  end
end
