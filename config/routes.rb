Rails.application.routes.draw do
  resources :posts
  resources :newsletters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "newsletters#index"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root 'newsletters#index', as: :authenticated_root
      get 'users/sign_out' => 'devise/sessions#destroy'
      get 'posts/:newsletter_id', to: 'posts#new'
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end
end
