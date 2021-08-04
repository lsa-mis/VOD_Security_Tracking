ActiveAdmin.register LegacyOsRecord do
  menu parent: 'Main Tables', priority: 1

  before_action :skip_sidebar!, only: :index
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id, :incomplete, :deleted_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:owner_username, :owner_full_name, :dept, :phone, :additional_dept_contact, :additional_dept_contact_phone, :support_poc, :legacy_os, :unique_app, :unique_hardware, :unique_date, :remediation, :exception_approval_date, :review_date, :review_contact, :justification, :local_it_support_group, :notes, :data_type_id, :device_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :archived
  scope :active, :default => true
 
  actions :index, :show

  action_item :unarchive, only: :show do
    text_node link_to("Unarchive record", unarchive_legacy_os_record_path(legacy_os_record), method: :post) unless legacy_os_record.deleted_at.nil?
  end

  index do
    actions
    column :incomplete
    column :owner_full_name
    column :device_id
    column :legacy_os
    column :updated_at
    column :data_type_id
    column :review_date
    column "Archived at" do |lor|
      lor.deleted_at
    end
  end

  show do
    attributes_table do
      row "Archived at" do |lor|
        lor.deleted_at
      end
      row :incomplete
      row :owner_username
      row :owner_full_name
      row :dept
      row :phone
      row :additional_dept_contact
      row :additional_dept_contact_phone
      row :support_poc
      row :legacy_os
      row :unique_app
      row :unique_hardware
      row :unique_date
      row :remediation
      row :exception_approval_date
      row :review_date
      row :review_contact
      row :justification
      row :local_it_support_group
      row :notes
      row :data_type_id
      row :device_id
    end
    panel "Attachments" do 
      if legacy_os_record.attachments.attached?
         table_for legacy_os_record.attachments do 
          column(:filename) { |item| link_to item.filename, url_for(item)}
        end
      end
    end
    panel "TDX Tickets" do
      table_for legacy_os_record.tdx_tickets do
        column(:ticket_link) { |item| link_to item.ticket_link, url_for(item.ticket_link) }
      end
    end
  end
end
