Rails.application.routes.draw do
  devise_for :users

  authenticate :user do
    root "posts#index", as: :authenticated_root
  end

  unauthenticated do
    root "devise/sessions#new", as: :unauthenticated_root
  end

  resources :users, only: [:index, :show] do
    member do
      post :follow
      delete :unfollow
      post :accept_follow
      delete :reject_follow
    end
  end

  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  resources :commments, only: [] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  resources :likes, only: [:create, :destroy]
end
