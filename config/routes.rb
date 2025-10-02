Rails.application.routes.draw do
  devise_for :users
  
  resources :users, only: [:index, :show]

  authenticate :user do
    root "users#index", as: :authenticated_root
  end

  unauthenticated do
    root "devise/sessions#new", as: :unauthenticated_root
  end
end
