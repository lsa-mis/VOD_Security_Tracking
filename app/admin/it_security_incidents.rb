ActiveAdmin.register ItSecurityIncident do
  menu parent: 'Main Tables', priority: 1

  before_action :skip_sidebar!, only: :index
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :title, :date, :people_involved, :equipment_involved, :remediation_steps, :estimated_financial_cost, :notes, :it_security_incident_status_id, :data_type_id, :incomplete, :deleted_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:date, :people_involved, :equipment_involved, :remediation_steps, :estimated_financial_cost, :notes, :it_security_incident_status_id, :data_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  scope :archived
  scope :active, :default => true

  actions :index, :show

  action_item :unarchive, only: :show do
    text_node link_to("Unarchive record", unarchive_it_security_incident_path(it_security_incident), method: :post) unless it_security_incident.deleted_at.nil?
  end

  index do
    actions
    column "Status", sortable: :it_security_incident_status_id.name do |is|
      show_it_security_incident_status(is)
    end
    column :incomplete
    column :title
    column "Date of Incident" do |is|
      is.date
    end 
    column :people_involved
    column :data_type, sortable: :data_type_id.name
    column "Archived at" do |is|
      is.deleted_at
    end
  end

  show do
    attributes_table do
      row "Status" do |is|
        show_it_security_incident_status(is)
      end
      row "Archived at" do |is|
        is.deleted_at
      end
      row :incomplete
      row :title
      row :date
      row :people_involved
      row :equipment_involved
      row :remediation_steps
      row :estimated_financial_cost
      row :notes
      row :it_security_incident_status_id
      row :data_type_id
    end
    panel "Attachments" do 
      if it_security_incident.attachments.attached?
         table_for it_security_incident.attachments do 
          column(:filename) { |item| link_to item.filename, url_for(item)}
        end
      end
    end
    panel "TDX Tickets" do
      table_for it_security_incident.tdx_tickets do
        column(:ticket_link) { |item| link_to item.ticket_link, url_for(item.ticket_link) }
      end
    end
  end
end
