Rails.application.routes.draw do
  devise_for :users
  resources :it_security_incidents
  resources :sensitive_data_systems
  resources :legacy_os_records
  get 'dpa_exceptions/audit_log', to: 'dpa_exceptions#audit_log'
  resources :dpa_exceptions
  resources :devices
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'
end
