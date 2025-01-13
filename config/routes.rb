Rails.application.routes.draw do
  get "home/index"
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  
  namespace :admin do
    resources :users
  end

  namespace :company do
    get "workers/index"
    get "workers/show"
    get "workers/edit"
    get "workers/update"
    get "workers/destroy"
    resources :workers, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch 'change_role'
      end
    end
  end

  resources :services do
    collection do
      get 'export_pdf'
      get 'export_excel'
      get 'export_csv'
    end
  end

  resources :jobs do
    member do
      get 'export_pdf'
      get 'export_excel'
      get 'export_csv'
    end
  end
  
  authenticated :user do
    root 'jobs#index', as: :authenticated_root
  end
  
  root 'home#index'
end