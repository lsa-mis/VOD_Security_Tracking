ActiveAdmin.register SensitiveDataSystem do
  menu parent: 'Main Tables', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :device_id, :incomplete
  #
  # or
  #
  # permit_params do
  #   permitted = [:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :device_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :archived
  scope :active, :default => true
  
end
