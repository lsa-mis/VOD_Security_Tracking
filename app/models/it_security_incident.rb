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
  has_many :tdx_tickets, as: :records_to_tdx
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
            :data_type_id, :it_security_incident_status_id, presence: true
  validate :acceptable_attachments


  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "data_type_id", "date", "deleted_at", "estimated_financial_cost", "id", "incomplete", "it_security_incident_status_id", "title", "updated_at"]
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

  # require 'nokogiri'

  def self.to_csv
    fields = %w{id incomplete title date people_involved equipment_involved remediation_steps
              estimated_financial_cost notes it_security_incident_status_id data_type_id tdx_tickets}
    header = %w{link incomplete title date people_involved equipment_involved remediation_steps
              estimated_financial_cost notes it_security_incident_status data_type tdx_tickets}
    header.map! { |e| e.titleize.upcase }
    key_id = 'id'
    CSV.generate(headers: true) do |csv|
      csv << header
      all.each do |a|
        row = []
        record_id = a.attributes.values_at(key_id)[0]
        fields.each do |key|
          if key == 'id'
            row << "http://localhost:3000/it_security_incidents/" + a.attributes.values_at(key)[0].to_s
          elsif key == 'data_type_id' && a.data_type_id.present?
            row << DataType.find(a.attributes.values_at(key)[0]).display_name
          elsif key == 'it_security_incident_status_id'
            row << ItSecurityIncidentStatus.find(a.attributes.values_at(key)[0]).name
          elsif ['people_involved', 'equipment_involved', 'remediation_steps', 'notes'].include?(key)
            html_content = ItSecurityIncident.find(record_id).send(key).body
            text_content = Nokogiri::HTML(html_content).text.strip
            row << text_content
          elsif key == 'tdx_tickets' && ItSecurityIncident.find(record_id).tdx_tickets.present?
            tickets = ""
            ItSecurityIncident.find(record_id).tdx_tickets.each do |ticket|
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
    "#{self.title} - #{self.id}"
  end
  
end
