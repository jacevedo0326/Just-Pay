Rails.application.routes.draw do
  resources :services
  resources :jobs do
    member do
      get 'export_pdf'
      get 'export_excel'
      get 'export_csv'
    end
  end
  
  root "jobs#index"  # Optional: make jobs list the homepage
end