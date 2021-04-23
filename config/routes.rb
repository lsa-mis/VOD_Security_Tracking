Rails.application.routes.draw do
  devise_for :users

  post 'archive_it_security_incident/:id', to: 'it_security_incidents#archive', as: :archive_it_security_incident
  resources :it_security_incidents

  post 'archive_sensitive_data_system/:id', to: 'sensitive_data_systems#archive', as: :archive_sensitive_data_system
  resources :sensitive_data_systems

  post 'archive_legacy_os_record/:id', to: 'legacy_os_records#archive', as: :archive_legacy_os_record
  resources :legacy_os_records

  get 'dpa_exceptions/audit_log', to: 'dpa_exceptions#audit_log'
  post 'archive_dpa_exception/:id', to: 'dpa_exceptions#archive', as: :archive_dpa_exception
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
