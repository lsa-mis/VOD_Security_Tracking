ActiveAdmin.register SensitiveDataSystem do
  menu parent: 'Main Tables', priority: 1

  before_action :skip_sidebar!, only: :index
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :expected_duration_of_data_retention, :agreements_related_to_data_types, :review_date, :review_contact, :notes, :storage_location_id, :data_type_id, :device_id, :incomplete, :deleted_at
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
  
  actions :index, :show

  action_item :unarchive, only: :show do
    text_node link_to("Unarchive record", unarchive_sensitive_data_system_path(sensitive_data_system), method: :post) unless sensitive_data_system.deleted_at.nil?
  end

  index do
    actions
    column "Status", sortable: :sensitive_data_system_status_id.name do |sds|
      show_sensitive_data_system_status(sds)
    end
    column :incomplete
    column :owner_full_name
    column :dept
    column :storage_location_id
    column :device.name
    column :data_type.name
    column :updated_at
    column "Archived at" do |sds|
      sds.deleted_at
    end
  end

  show do
    attributes_table do
      row "Archived at" do |sds|
        sds.deleted_at
      end
      row :incomplete
      row :name
      row :owner_username
      row :owner_full_name
      row :dept
      row :phone
      row :additional_dept_contact
      row :additional_dept_contact_phone
      row :support_poc
      row :expected_duration_of_data_retention
      row :agreements_related_to_data_types
      row :review_date
      row :review_contact
      row :notes
      row :storage_location_id
      row :data_type.name
      row :device.name
    end
    panel "Attachments" do 
      if sensitive_data_system.attachments.attached?
         table_for sensitive_data_system.attachments do 
          column(:filename) { |item| link_to item.filename, url_for(item)}
        end
      end
    end
    panel "TDX Tickets" do
      table_for sensitive_data_system.tdx_tickets do
        column(:ticket_link) { |item| link_to item.ticket_link, url_for(item.ticket_link) }
      end
    end
  end
end

