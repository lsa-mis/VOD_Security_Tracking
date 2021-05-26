ActiveAdmin.register ItSecurityIncident do
  menu parent: 'Main Tables', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id, :incomplete
  #
  # or
  #
  # permit_params do
  #   permitted = [:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_finacial_cost, :notes, :it_security_incident_status_id, :data_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  scope :archived
  scope :active, :default => true
  
end
