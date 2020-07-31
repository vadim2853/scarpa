require 'constraints/social_network_crawlers'

Rails.application.routes.draw do
  %i(404 422 500).each do |code|
    get code, to: 'errors#show', code: code
  end

  mount LetsencryptPlugin::Engine, at: '/'

  # The priority is based upon order of creation: first created -> highest priority.
  root 'simple_pages#index'

  get 'winery', controller: :simple_pages
  get 'coming_soon', controller: :simple_pages
  get 'live_streaming', controller: :simple_pages
  get 'contacts', controller: :simple_pages
  get 'club', controller: :simple_pages
  get 'order_success', controller: :simple_pages
  get 'confirm', controller: :simple_pages

  resources :map_markers, only: [:index, :show] do
    collection do
      get :nearest
      get :address_autocomplete
    end
  end

  get :cabinet, to: 'cabinets#index'
  get :settings, to: 'cabinets#edit'
  resource :cabinets, only: [:update] do
    post :avatar_upload, on: :collection
  end
  resource :passwords, only: [:update]

  resources :wine_tours, only: [:index, :show]
  resources :blogs, only: [:index, :show]
  resources :news, only: [:index, :show]
  resources :products, only: :show
  resources :grades, only: [:index, :show, :update] do
    post :clear_sessions, on: :collection
  end

  pdf = 'pdf'
  constraints(-> (request) { Constraints::SocialNetworkCrawlers.matches?(request) }) do
    resources :certificates, only: :show, defaults: { format: 'html' }
  end
  resources :certificates, only: :show, defaults: { format: pdf }
  resources :tickets, only: :show, defaults: { format: pdf }, constraints: { format: pdf }
  resources :invoices, only: :show, defaults: { format: pdf }, constraints: { format: pdf }

  #get :party_calculator, controller: :party_calculator, action: :index

  get 'wines', controller: :products
  get 'aged_vintages', controller: :products
  get 'grappa_vermouth', controller: :products

  mount Ckeditor::Engine => '/ckeditor'
  mount Spree::Core::Engine, at: '/'

  #namespace :api, defaults: { format: 'json' } do
    #namespace :v1 do
      #resources :quizzes, only: :index
    #end
  #end

  namespace :ui, defaults: { format: 'json' } do
    namespace :v1 do
      resources :products, only: [] do
        resources :comments, only: %i(create index destroy), defaults: { commentable_type: 'Spree::Product' }
      end

      resources :blogs, only: [] do
        resources :comments, only: %i(create index destroy), defaults: { commentable_type: 'Spree::BlogEntry' }
      end

      resources :comments, only: [] do
        resources :comments, only: %i(create destroy), defaults: { commentable_type: 'Spree::Comment' }
      end

      resources :wine_tours, only: [] do
        resources :wine_tours_leftovers, only: :show, path: :leftovers
      end
    end
  end

  devise_for :spree_user,
             class_name: 'Spree::User',
             controllers: {
               sessions: 'spree/user_sessions',
               registrations: 'spree/user_registrations',
               confirmations: 'spree/user_confirmations'
             },
             skip: :unlocks,
             path_names: { sign_out: 'logout' },
             path_prefix: :user

  devise_scope :spree_user do
    post '/login', to: 'user_sessions#create', as: :create_new_session
    get '/logout', to: 'user_sessions#destroy', as: :logout
    post '/signup', to: 'user_registrations#create', as: :registration
  end

  patch '/checkout/update/:state', to: 'checkout#update', as: :update_checkout
  get '/checkout/:state', to: 'checkout#edit', as: :checkout_state
  get '/checkout', to: 'checkout#edit', as: :checkout
  get '/checkout_complete', to: 'checkout#complete', as: :checkout_complete

  get 'order_details/:id' => 'orders#show', as: :order_details
  resources :orders, only: [:edit] do
    post :populate, on: :collection
  end

  get '/cart', to: 'orders#edit', as: :cart
  patch '/cart', to: 'orders#update', as: :update_cart

  get '/cart_link', to: 'store#cart_link', as: :cart_link
end

Spree::Core::Engine.add_routes do
  post '/paypal', to: 'paypal#express', as: :paypal_express
  get '/paypal/confirm', to: 'paypal#confirm', as: :confirm_paypal
  get '/paypal/cancel', to: 'paypal#cancel', as: :cancel_paypal
  get '/paypal/notify', to: 'paypal#notify', as: :notify_paypal

  namespace :admin do
    resources :orders, only: [] do
      resources :payments, only: [] do
        member do
          get 'paypal_refund'
          post 'paypal_refund'
        end
      end
    end

    resources :blog_entries
    resources :news_entries
    resources :quizzes, only: :index
    resources :related_news_entries, only: [:create, :destroy]
    resources :related_products, only: [:create, :destroy]
    resources :wine_glasses, only: [:create, :destroy]
    resources :slides, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :wineries do
      post :update_positions, on: :collection
    end

    resources :map_markers do
      collection do
        get :autocomplete
      end
    end

    resources :products do
      resources :topics, only: [:index, :new, :create, :edit, :update, :destroy] do
        post :update_positions, on: :collection
      end

      resources :audios, only: [:index, :new, :create, :edit, :update, :destroy] do
        post :update_positions, on: :collection
      end

      resources :product_descriptions, only: [:index, :new, :create, :edit, :update, :destroy] do
        post :update_positions, on: :collection
      end
    end
    resources :featured_items

    namespace :calculator do
      resources :events, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :event_products, only: [:create, :destroy]
      resources :backgrounds, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :months, only: [:index, :edit, :update]
      resources :month_products, only: [:create, :destroy]
    end

    resources :nominations, only: [:index, :new, :create, :edit, :update, :destroy] do
      post :update_positions, on: :collection
    end

    resources :quizzes, only: [:index, :new, :create, :edit, :update, :destroy] do
      post :update_positions, on: :collection
    end

    resources :grades, only: [:index, :new, :create, :edit, :update, :destroy] do
      post :update_positions, on: :collection
    end

    resources :questions, only: [:index, :new, :create, :edit, :update, :destroy] do
      post :update_positions, on: :collection
    end
  end
end
