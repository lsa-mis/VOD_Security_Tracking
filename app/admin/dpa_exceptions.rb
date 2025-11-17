ActiveAdmin.register DpaException do
  menu parent: 'Main Tables', priority: 1, label: 'DSA Exceptions'

  controller do
    before_action :set_page_title

    private

    def set_page_title
      @page_title = 'DSA Exceptions'
    end
  end

  before_action :skip_sidebar!, only: :index
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :review_date_exception_first_approval_date, :third_party_product_service, :department_id, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date_exception_renewal_date_due, :notes, :data_type_id, :incomplete, :review_date_exception_review_date, :dpa_exception_status_id, :deleted_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:review_date, :third_party_product_service, :department_id, :point_of_contact, :review_findings, :review_summary, :lsa_security_recommendation, :lsa_security_determination, :lsa_security_approval, :lsa_technology_services_approval, :exception_approval_date, :notes, :sla_agreement, :data_type_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  scope :archived
  scope :active, :default => true

  actions :index, :show

  action_item :unarchive, only: :show do
    text_node link_to("Unarchive record", unarchive_dpa_exception_path(dpa_exception), method: :post) unless dpa_exception.deleted_at.nil?
  end

  index do
    actions
    column "Status", sortable: :dpa_exception_status_id.name do |dps|
      show_dpa_exception_status(dps)
    end
    column :incomplete
    column :review_date_exception_first_approval_date
    column :third_party_product_service
    column  "Department used by" do |dps|
      dps.department.name
    end
    column :data_type, sortable: :data_type_id.name
    column "Next Review Due Date" do |dps|
      dps.review_date_exception_review_date
    end
    column "Last Reviewed Date" do |dps|
      dps.exception_approval_date_exception_renewal_date_due
    end
    column "Archived at" do |dps|
      dps.deleted_at
    end
  end

  show do
    attributes_table do
      row "Status" do |dps|
        show_dpa_exception_status(dps)
      end
      row "Archived at" do |dps|
        dps.deleted_at
      end
      row :incomplete
      row :review_date_exception_first_approval_date
      row :third_party_product_service
      row  "Department used by" do |dps|
        dps.department.name
      end
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
