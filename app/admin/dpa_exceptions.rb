ActiveAdmin.register DpaException do
  menu parent: 'Main Tables', priority: 1

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :review_date_exception_first_approval_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date_exception_renewal_date_due, :notes, :sla_agreement, :data_type_id, :incomplete, :review_date_exception_review_date, :dpa_exception_status_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:review_date, :third_party_product_service, :used_by, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date, :notes, :sla_agreement, :data_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :archived
  scope :active, :default => true
  
  show do
    attributes_table do
      row "Status" do |dps|
        show_dpa_exception_status(dps)
      end
      row :incomplete
      row :review_date_exception_first_approval_date
      row :third_party_product_service
      row :used_by
      row :point_of_contact
      row :review_findings
      row :review_summary
      row :lsa_security_recommendation
      row :lsa_security_determination
      row :lsa_security_approval
      row :lsa_technology_services_approval
      row :exception_approval_date_exception_renewal_date_due
      row :review_date_exception_review_date
      row :notes
      row :sla_agreement
      row :sla_attachment do |sla|
        if sla.sla_attachment.attached?
            sla.sla_attachment.filename
            link_to sla.sla_attachment.filename, url_for(sla.sla_attachment)
        end
      end
      row :data_type.name
    end
    panel "Attachments" do 
      if dpa_exception.attachments.attached?
         table_for dpa_exception.attachments do 
          column(:filename) { |item| link_to item.filename, url_for(item)}
        end
      end
    end
    panel "TDX Tickets" do
      table_for dpa_exception.tdx_tickets do
        column(:ticket_link) { |item| link_to item.ticket_link, url_for(item.ticket_link) }
      end
    end
  end
end
