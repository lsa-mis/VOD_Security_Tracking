# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  estimated_financial_cost       :integer
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
#  title                          :string(255)      not null
#
class ItSecurityIncident < ApplicationRecord
  belongs_to :it_security_incident_status
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx, dependent: :destroy
  has_rich_text :people_involved
  has_one :people_involved, class_name: 'ActionText::RichText', as: :record
  has_rich_text :equipment_involved
  has_one :equipment_involved, class_name: 'ActionText::RichText', as: :record
  has_rich_text :remediation_steps
  has_one :remediation_steps, class_name: 'ActionText::RichText', as: :record
  has_rich_text :notes
  has_one :notes, class_name: 'ActionText::RichText', as: :record
  has_many_attached :attachments
  before_save :if_not_complete

  audited

  validates :date, :people_involved, :equipment_involved, :remediation_steps,
            :data_type_id, :it_security_incident_status_id, :title, presence: true
  validates :estimated_financial_cost, numericality: true, allow_nil: true
  validate :acceptable_attachments


  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data_type_id", "date", "deleted_at", "estimated_financial_cost", "id", "incomplete", "it_security_incident_status_id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["attachments_attachments", "attachments_blobs", "audits", "data_type", "equipment_involved", "it_security_incident_status", "notes", "people_involved", "remediation_steps", "rich_text_equipment_involved", "rich_text_notes", "rich_text_people_involved", "rich_text_remediation_steps", "tdx_tickets"]
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
    self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete", "notes").all? {|k, v| v.present?} ? false : true
  end

  def display_name
    "#{self.title} - #{self.id}"
  end

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_headers
      csv_records.each { |record| csv << build_row(record) }
    end
  end

  private

  def self.csv_fields
    %w[
      id incomplete title date people_involved equipment_involved remediation_steps
      estimated_financial_cost notes it_security_incident_status_id data_type_id
      tdx_tickets
    ]
  end

  def self.csv_headers
    %w[
      link incomplete title date people_involved equipment_involved remediation_steps
      estimated_financial_cost notes it_security_incident_status data_type
      tdx_tickets
    ].map(&:titleize).map(&:upcase)
  end

  def self.csv_records
    includes(:data_type, :it_security_incident_status, :tdx_tickets,
            :people_involved, :equipment_involved, :remediation_steps, :notes)
  end

  def self.build_row(record)
    csv_fields.each_with_object([]) do |field, row|
      row << format_field(record, field)
    end
  end

  def self.format_field(record, field)
    case field
    when 'id'
      generate_url(record)
    when 'data_type_id'
      record.data_type&.display_name
    when 'it_security_incident_status_id'
      record.it_security_incident_status&.name
    when 'people_involved', 'equipment_involved', 'remediation_steps', 'notes'
      record.send(field)&.to_plain_text || ''
    when 'tdx_tickets'
      record.tdx_tickets.map(&:ticket_link).join(' ; ')
    else
      record.attributes[field]
    end
  end

  def self.generate_url(record)
    Rails.application.routes.url_helpers.it_security_incident_url(
      record,
      host: Rails.application.config.action_mailer.default_url_options[:host]
    )
  end

end
