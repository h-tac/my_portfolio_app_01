Rails.application.routes.draw do
  root to: 'home#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :spots do
    collection do
      get 'list'
    end
  end
end
