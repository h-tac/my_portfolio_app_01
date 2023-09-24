Rails.application.routes.draw do
  root to: 'home#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resource :users do
    collection do
      get 'delete_confirm'
      get 'list'
      get 'spots'
      get 'comments'
      delete 'remove'
    end
  end
  resources :spots do
    resources :comments, shallow: true, only: %i[create destroy]
    collection do
      get 'list'
      get 'favorites'
      get 'search'
    end
  end
  resources :favorites, only: %i[create destroy]
end
