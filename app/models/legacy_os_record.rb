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

  def display_name
    "#{self.legacy_os} - #{self.id}"
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
      id incomplete owner_username owner_full_name department_id phone
      additional_dept_contact additional_dept_contact_phone support_poc
      legacy_os unique_app unique_hardware unique_date remediation
      exception_approval_date review_date review_contact justification
      local_it_support_group notes data_type_id device_id tdx_tickets
    ]
  end

  def self.csv_headers
    %w[
      link incomplete owner_username owner_full_name department phone
      additional_dept_contact additional_dept_contact_phone support_poc
      legacy_os unique_app unique_hardware unique_date remediation
      exception_approval_date review_date review_contact justification
      local_it_support_group notes data_type device:_hostname device:_serial
      tdx_tickets
    ].map(&:titleize).map(&:upcase)
  end

  def self.csv_records
    includes(:data_type, :department, :device, :tdx_tickets,
            :remediation, :justification, :notes)
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
    when 'department_id'
      record.department&.name
    when 'device_id'
      format_device(record.device)
    when 'remediation', 'justification', 'notes'
      record.send(field)&.to_plain_text || ''
    when 'tdx_tickets'
      record.tdx_tickets.map(&:ticket_link).join(' ; ')
    else
      record.attributes[field]
    end
  end

  def self.generate_url(record)
    Rails.application.routes.url_helpers.legacy_os_record_url(
      record,
      host: Rails.application.config.action_mailer.default_url_options[:host]
    )
  end

  def self.format_device(device)
    return unless device
    [device.display_hostname, device.display_serial]
  end

end
