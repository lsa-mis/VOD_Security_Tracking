Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    # root to: 'users/sessions#new'
    get 'sign_in', to: 'users/sessions#new'
    get '/users/sign_out', to: 'users/sessions#destroy'
  end

  resources :it_security_incidents do
    resources :tdx_tickets, module: :it_security_incidents
  end

  get 'sensitive_data_systems/audit_log/:id', to: 'sensitive_data_systems#audit_log', as: :sensitive_data_system_audit_log
  resources :sensitive_data_systems do
    resources :tdx_tickets, module: :sensitive_data_systems
  end

  get 'legacy_os_records/audit_log/:id', to: 'legacy_os_records#audit_log', as: :legacy_os_record_audit_log
  resources :legacy_os_records do
    resources :tdx_tickets, module: :legacy_os_records
  end

  get 'dpa_exceptions/audit_log/:id', to: 'dpa_exceptions#audit_log', as: :dpa_exception_audit_log
  get 'dpa_exceptions/delete_file_attachment/:id', to: 'dpa_exceptions#delete_file_attachment', as: :delete_sla_agreement
  resources :dpa_exceptions do
    resources :tdx_tickets, module: :dpa_exceptions
  end
  
  post 'archive_it_security_incident/:id', to: 'it_security_incidents#archive', as: :archive_it_security_incident
  post 'archive_sensitive_data_system/:id', to: 'sensitive_data_systems#archive', as: :archive_sensitive_data_system
  post 'archive_legacy_os_record/:id', to: 'legacy_os_records#archive', as: :archive_legacy_os_record
  post 'archive_dpa_exception/:id', to: 'dpa_exceptions#archive', as: :archive_dpa_exception
  
  resources :devices
  get 'update_device/:id', to: 'devices#update', as: :update_device

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/dashboard', to: 'static_pages#dashboard'

end
