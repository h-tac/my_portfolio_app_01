Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root to: 'home#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resource :users do
    collection do
      get 'activate'
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
  resources :email_changes, only: %i[create] do
    collection do
      get 'confirm'
    end
  end
  resources :password_resets, only: %i[new create edit update]
  resources :search_places, only: %i[index create]
end
