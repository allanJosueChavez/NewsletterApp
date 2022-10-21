Rails.application.routes.draw do
  # resources :subscribtions
  resources :posts
  resources :newsletters
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "newsletters#feed"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  devise_scope :user do
    authenticated :user do
      root 'newsletters#index', as: :authenticated_root
      get 'users/sign_out' => 'devise/sessions#destroy'
      get 'users/:user_id/profile', to: 'posts#show_profile', as: 'profile'
      get 'discover', to: 'newsletters#discover', as: 'discover'
      get 'my_newsletters', to: 'newsletters#mine', as: 'mine'
      get 'feed', to: 'newsletters#feed', as: 'feed'
      get 'newsletters/:id/posts', to: 'newsletters#posts', as: 'newsletter_posts'
      get 'newsletters/:id/posts/new', to: 'posts#new', as: 'newsletter_post_new'
      get 'newsletters/:id/subscriptions', to: 'newsletters#subscribe', as: 'newsletter_subscription_new'
      delete 'newsletters/:id/subscriptions/destroy', to: 'newsletters#unsubscribe', as: 'newsletter_subscription_destroy'
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end
  end
end
