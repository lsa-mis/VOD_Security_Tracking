# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)      not null
#  owner_full_name               :string(255)      not null
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  local_it_support_group        :string(255)
#  data_type_id                  :bigint
#  device_id                     :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  incomplete                    :boolean          default(FALSE)
#  department_id                 :bigint           not null
#
class LegacyOsRecord < ApplicationRecord
  belongs_to :data_type, optional: true
  belongs_to :device
  belongs_to :department
  has_many :tdx_tickets, as: :records_to_tdx
  has_rich_text :remediation
  has_one :remediation, class_name: 'ActionText::RichText', as: :record
  has_rich_text :justification
  has_one :justification, class_name: 'ActionText::RichText', as: :record
  has_rich_text :notes
  has_one :notes, class_name: 'ActionText::RichText', as: :record

  accepts_nested_attributes_for :device

  has_many_attached :attachments
  before_save :if_not_complete

  audited

  validates :owner_username, :owner_full_name, :department_id, :phone, presence: true
  validate :unique_app_or_unique_hardware
  validate :acceptable_attachments

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def self.ransackable_attributes(auth_object = nil)
    ["additional_dept_contact", "additional_dept_contact_phone", "created_at", "data_type_id", "deleted_at", "department_id", "device_id", "exception_approval_date", "id", "incomplete", "legacy_os", "local_it_support_group", "owner_full_name", "owner_username", "phone", "review_contact", "review_date", "support_poc", "unique_app", "unique_date", "unique_hardware", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["attachments_attachments", "attachments_blobs", "audits", "data_type", "department", "device", "justification", "notes", "remediation", "rich_text_justification", "rich_text_notes", "rich_text_remediation", "tdx_tickets"]
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

  def unique_app_or_unique_hardware
    errors.add(:unique_app, "or Unique Hardware needs a value") unless unique_app.present? || unique_hardware.present?
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
    not_completed = self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete", "unique_app", "unique_hardware", "notes").all? {|k, v| v.present?} ? false : true
    unless not_completed
      not_completed = true unless unique_app.present? || unique_hardware.present?
    end
    return not_completed
  end

  # require 'nokogiri'

  def self.to_csv
    fields = %w{id incomplete owner_username owner_full_name department_id phone additional_dept_contact
              additional_dept_contact_phone support_poc legacy_os unique_app unique_hardware unique_date
              remediation exception_approval_date review_date review_contact justification
              local_it_support_group notes data_type_id device_id tdx_tickets}
    header = %w{link incomplete owner_username owner_full_name department phone additional_dept_contact
              additional_dept_contact_phone support_poc legacy_os unique_app unique_hardware unique_date
              remediation exception_approval_date review_date review_contact justification
              local_it_support_group notes data_type device:_hostname device:_serial tdx_tickets}
    header.map! { |e| e.titleize.upcase }
    key_id = 'id'
    CSV.generate(headers: true) do |csv|
      csv << header
      all.each do |a|
        row = []
        record_id = a.attributes.values_at(key_id)[0]
        fields.each do |key|
          if key == 'id'
            row << "http://localhost:3000/legacy_os_records/" + a.attributes.values_at(key)[0].to_s
          elsif key == 'data_type_id' && a.data_type_id.present?
            row << DataType.find(a.attributes.values_at(key)[0]).display_name
          elsif key == 'department_id' && a.department_id.present?
            row << Department.find(a.attributes.values_at(key)[0]).name
          elsif key == 'device_id' && a.device_id.present?
            row << Device.find(a.attributes.values_at(key)[0]).display_hostname
            row << Device.find(a.attributes.values_at(key)[0]).display_serial
          elsif ['remediation', 'justification', 'notes'].include?(key)
            html_content = LegacyOsRecord.find(record_id).send(key).body
            text_content = Nokogiri::HTML(html_content).text.strip
            row << text_content
          elsif key == 'tdx_tickets' && LegacyOsRecord.find(record_id).tdx_tickets.present?
            tickets = ""
            LegacyOsRecord.find(record_id).tdx_tickets.each do |ticket|
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
    "#{self.device.display_name}   #{self.legacy_os}"
  end

end
