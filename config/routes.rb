Rails.application.routes.draw do
  root to: 'static_pages#home'
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_scope :user do
    # root to: 'users/sessions#new'
    get 'sign_in', to: 'users/sessions#new'
    get '/users/sign_out', to: 'users/sessions#destroy'
    post 'registrations/duo_verify', to: 'registrations#duo_verify', as: :duo_verify
    get 'registrations/duo', to: 'registrations#duo', as: :duo
    authenticated do
     root :to => "registrations#duo", as: :new_root
    end
  end

  get 'it_security_incidents/audit_log/:id', to: 'it_security_incidents#audit_log', as: :it_security_incident_audit_log
  resources :it_security_incidents do
    resources :tdx_tickets, module: :it_security_incidents
  end

  get 'sensitive_data_systems/audit_log/:id', to: 'sensitive_data_systems#audit_log', as: :sensitive_data_system_audit_log
  resources :sensitive_data_systems do
    resources :tdx_tickets, module: :sensitive_data_systems
  end

  get 'storage_locations/is_device_required/:id', to: 'storage_locations#is_device_required?'
  get 'data_classification_levels/get_data_types/:id', to: 'data_classification_levels#get_data_types'

  get 'legacy_os_records/audit_log/:id', to: 'legacy_os_records#audit_log', as: :legacy_os_record_audit_log
  resources :legacy_os_records do
    resources :tdx_tickets, module: :legacy_os_records
  end

  get 'dpa_exceptions/audit_log/:id', to: 'dpa_exceptions#audit_log', as: :dpa_exception_audit_log
  resources :dpa_exceptions do
    resources :tdx_tickets, module: :dpa_exceptions
  end

  resources :tdx_tickets

  get 'dpa_exceptions/audit_log', to: 'dpa_exceptions#audit_log'
  get 'application/delete_file_attachment/:id', to: 'application#delete_file_attachment', as: :delete_file

  
  post 'archive_it_security_incident/:id', to: 'it_security_incidents#archive', as: :archive_it_security_incident
  post 'archive_sensitive_data_system/:id', to: 'sensitive_data_systems#archive', as: :archive_sensitive_data_system
  post 'archive_legacy_os_record/:id', to: 'legacy_os_records#archive', as: :archive_legacy_os_record
  post 'archive_dpa_exception/:id', to: 'dpa_exceptions#archive', as: :archive_dpa_exception
  
  post 'unarchive_it_security_incident/:id', to: 'it_security_incidents#unarchive', as: :unarchive_it_security_incident
  post 'unarchive_sensitive_data_system/:id', to: 'sensitive_data_systems#unarchive', as: :unarchive_sensitive_data_system
  post 'unarchive_legacy_os_record/:id', to: 'legacy_os_records#unarchive', as: :unarchive_legacy_os_record
  post 'unarchive_dpa_exception/:id', to: 'dpa_exceptions#unarchive', as: :unarchive_dpa_exception

  resources :devices
  get 'update_device/:id', to: 'devices#update', as: :update_device

  resources :infotexts

  resources :reports
  get 'run_report', to: 'reports#run_report', as: :run_report

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/dashboard', to: 'static_pages#dashboard'

end
