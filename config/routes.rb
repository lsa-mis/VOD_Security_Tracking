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

  get 'legacy_os_records/audit_log/:id', to: 'legacy_os_records#audit_log', as: :legacy_os_record_audit_log
  resources :legacy_os_records do
    resources :tdx_tickets, module: :legacy_os_records
  end

  get 'dpa_exceptions/audit_log/:id', to: 'dpa_exceptions#audit_log', as: :dpa_exception_audit_log
  get 'dpa_exceptions/delete_file_attachment/:id', to: 'dpa_exceptions#delete_file_attachment', as: :delete_sla_agreement
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
  
  resources :devices
  get 'update_device/:id', to: 'devices#update', as: :update_device

  resources :infotexts

  get '/admin/reports/legacy_os_records_review_date_next_month', to: 'admin/reports#legacy_os_records_review_date_next_month', as: :admin_legacy_os_records_review_date_next_month
  get '/admin/reports/systems_with_selected_data_type', to: 'admin/reports#systems_with_selected_data_type', as: :admin_systems_with_selected_data_type

  resources :reports
  get 'legacy_os_records_review_date_next_month', to: 'reports#legacy_os_records_review_date_next_month', as: :legacy_os_records_review_date_next_month
  get 'systems_with_selected_data_type', to: 'reports#systems_with_selected_data_type', as: :systems_with_selected_data_type
  get 'sensitive_data_system_review_date_this_month', to: 'reports#sensitive_data_system_review_date_this_month', as: :sensitive_data_system_review_date_this_month
  get 'dpa_exception_review_date_this_month', to: 'reports#dpa_exception_review_date_this_month', as: :dpa_exception_review_date_this_month
  get 'records_added_last_week', to: 'reports#records_added_last_week', as: :records_added_last_week
  get 'systems_with_selected_data_classification_level', to: 'reports#systems_with_selected_data_classification_level', as: :systems_with_selected_data_classification_level

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/dashboard', to: 'static_pages#dashboard'

end
