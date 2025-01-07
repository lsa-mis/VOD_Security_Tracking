# == Schema Information
#
# Table name: dpa_exceptions
#
#  id                                                 :bigint           not null, primary key
#  review_date_exception_first_approval_date          :datetime
#  third_party_product_service                        :string(255)      not null
#  point_of_contact                                   :string(255)
#  lsa_security_approval                              :string(255)
#  lsa_technology_services_approval                   :string(255)
#  exception_approval_date_exception_renewal_date_due :datetime
#  sla_agreement                                      :string(255)
#  data_type_id                                       :bigint
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  deleted_at                                         :datetime
#  incomplete                                         :boolean          default(FALSE)
#  review_date_exception_review_date                  :datetime
#  dpa_exception_status_id                            :bigint           not null
#  department_id                                      :bigint           not null
#
class DpaException < ApplicationRecord
  belongs_to :data_type, optional: true
  belongs_to :dpa_exception_status
  has_many :tdx_tickets, as: :records_to_tdx
  belongs_to :department
  has_rich_text :review_findings
  has_one :review_findings, class_name: 'ActionText::RichText', as: :record
  has_rich_text :notes
  has_one :notes, class_name: 'ActionText::RichText', as: :record
  has_rich_text :review_summary
  has_one :review_summary, class_name: 'ActionText::RichText', as: :record
  has_rich_text :lsa_security_recommendation
  has_one :lsa_security_recommendation, class_name: 'ActionText::RichText', as: :record
  has_rich_text :lsa_security_determination
  has_one :lsa_security_determination, class_name: 'ActionText::RichText', as: :record
  has_many_attached :attachments
  before_save :if_not_complete

  audited

  validates :review_date_exception_first_approval_date, :third_party_product_service,
            :department_id, presence: true
  validates :dpa_exception_status_id, presence: true
  validate :acceptable_attachments
  validate :review_date_after_first_approval

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data_type_id", "deleted_at", "department_id", "dpa_exception_status_id", "exception_approval_date_exception_renewal_date_due", "id", "incomplete", "lsa_security_approval", "lsa_technology_services_approval", "point_of_contact", "review_date_exception_first_approval_date", "review_date_exception_review_date", "sla_agreement", "third_party_product_service", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["attachments_attachments", "attachments_blobs", "audits", "data_type", "department", "dpa_exception_status", "lsa_security_determination", "lsa_security_recommendation", "notes", "review_findings", "review_summary", "rich_text_lsa_security_determination", "rich_text_lsa_security_recommendation", "rich_text_notes", "rich_text_review_findings", "rich_text_review_summary", "tdx_tickets"]
  end

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def unarchive
    self.update(deleted_at: nil)
  end

  def archived?
    self.deleted_at.present?
  end

  def acceptable_attachments
    return unless attachments.attached?

    acceptable_types = [
      "application/pdf", "text/plain", "image/jpg",
      "image/jpeg", "image/png",
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      "application/vnd.apple.pages",
      "application/vnd.apple.numbers",
      "application/x-tar",
      "application/zip",
      "application/x-bzip",
      "application/x-bzip2",
      "application/gzip",
      "application/x-7z-compressed"
    ]

    attachments.each do |att|
      unless att.byte_size <= 20.megabyte
        errors.add(:attachments, "is too big")
      end

      unless acceptable_types.include?(att.content_type)
        errors.add(:attachments, "must be an acceptable file type (pdf,txt,jpg,png,doc,xls,zip)")
      end
    end
  end

  def if_not_complete
    if self.not_completed?
      self.incomplete = true
    else
      self.incomplete = false
    end
  end

  def not_completed?
    not_completed = self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete", "notes", "sla_agreement").all? {|k, v| v.present?} ? false : true
  end

  def self.to_csv
    fields = %w{id incomplete dpa_exception_status_id review_date_exception_first_approval_date third_party_product_service
              department_id point_of_contact review_findings review_summary lsa_security_recommendation lsa_security_determination
              lsa_security_approval lsa_technology_services_approval exception_approval_date_exception_renewal_date_due notes
              data_type_id review_date_exception_review_date tdx_tickets}
    header = %w{link incomplete dpa_exception_status review_date_exception_first_approval_date third_party_product_service
              department_used_by point_of_contact review_findings review_summary lsa_security_recommendation lsa_security_determination
              lsa_security_approval lsa_technology_services_approval exception_approval_date_exception_renewal_date_due notes
              data_type review_date_exception_review_date tdx_tickets}
    header.map! { |e| e.titleize.upcase }
    key_id = 'id'
    CSV.generate(headers: true) do |csv|
      csv << header
      all.each do |a|
        row = []
        record_id = a.attributes.values_at(key_id)[0]
        fields.each do |key|
          if key == 'id'
            row << "http://localhost:3000/dpa_exceptions/" + a.attributes.values_at(key)[0].to_s
          elsif key == 'data_type_id' && a.data_type_id.present?
            row << DataType.find(a.attributes.values_at(key)[0]).display_name
          elsif key == 'department_id' && a.data_type_id.present?
            row << Department.find(a.attributes.values_at(key)[0]).name
          elsif key == 'dpa_exception_status_id' && a.dpa_exception_status_id.present?
            row << DpaExceptionStatus.find(a.attributes.values_at(key)[0]).name
          elsif ['review_findings', 'review_summary', 'lsa_security_recommendation', 'lsa_security_determination', 'notes'].include?(key)
            html_content = DpaException.find(record_id).send(key).body
            text_content = Nokogiri::HTML(html_content).text.strip
            row << text_content
          elsif key == 'tdx_tickets' && DpaException.find(record_id).tdx_tickets.present?
            tickets = ""
            DpaException.find(record_id).tdx_tickets.each do |ticket|
              tickets += ticket.ticket_link + " ; "
            end
            row << tickets
          else
            row << a.attributes.values_at(key)[0]
          end
        end
        csv << row
      end
    end
  end

  def display_name
    "#{self.third_party_product_service}"
  end

  def review_date_after_first_approval
    return unless review_date_exception_review_date.present? && review_date_exception_first_approval_date.present?

    if review_date_exception_review_date.to_date <= review_date_exception_first_approval_date.to_date
      errors.add(:review_date_exception_review_date, "must be after the first approval date")
    end
  end

end
