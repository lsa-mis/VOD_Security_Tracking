# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)      not null
#  phone                               :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)
#  expected_duration_of_data_retention :string(255)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime
#  review_contact                      :string(255)
#  storage_location_id                 :bigint
#  data_type_id                        :bigint
#  device_id                           :bigint
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#  incomplete                          :boolean          default(FALSE)
#  name                                :string(255)      not null
#  department_id                       :bigint           not null
#
class SensitiveDataSystem < ApplicationRecord
  belongs_to :storage_location, optional: true
  belongs_to :data_type, optional: true
  belongs_to :device, optional: true
  belongs_to :department
  has_many :tdx_tickets, as: :records_to_tdx
  has_rich_text :notes
  has_one :notes, class_name: 'ActionText::RichText', as: :record
  accepts_nested_attributes_for :device

  has_many_attached :attachments
  before_save :if_not_complete

  audited

  validates :owner_username, :owner_full_name, :department_id, presence: true
  validate :acceptable_attachments

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

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
      "application/x-tar"
    ]

    attachments.each do |att|
      unless att.byte_size <= 20.megabyte
        errors.add(:attachments, "is too big")
      end

      unless acceptable_types.include?(att.content_type)
        errors.add(:attachments, "must be an acceptable file type (pdf,txt,jpg,png,doc,xls)")
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
    not_completed = self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete", "device_id", "notes").all? {|k, v| v.present?} ? false : true
    if not_completed
      if self.storage_location_id.present?
        not_completed = false unless StorageLocation.find(self.storage_location_id).device_is_required && self.device_id.present?
      end
    end
    return not_completed
  end

  def self.to_csv
    fields = %w{id incomplete name owner_username owner_full_name department_id phone additional_dept_contact
                additional_dept_contact_phone support_poc expected_duration_of_data_retention agreements_related_to_data_types
                review_date review_contact notes storage_location_id data_type_id device_id tdx_tickets}
    header = %w{link incomplete name owner_username owner_full_name department phone additional_dept_contact
                additional_dept_contact_phone support_poc expected_duration_of_data_retention agreements_related_to_data_types
                review_date review_contact notes storage_location data_type device:_hostname_serial tdx_tickets}
    header.map! { |e| e.titleize.upcase }
    key_id = 'id'
    CSV.generate(headers: true) do |csv|
      csv << header
      all.each do |a|
        row = []
        record_id = a.attributes.values_at(key_id)[0]
        fields.each do |key|
          if key == 'id'
            row << "http://localhost:3000/sensitive_data_systems/" + a.attributes.values_at(key)[0].to_s
          elsif key == 'data_type_id' && a.data_type_id.present?
            row << DataType.find(a.attributes.values_at(key)[0]).display_name
          elsif key == 'storage_location_id' && a.data_type_id.present?
            row << StorageLocation.find(a.attributes.values_at(key)[0]).display_name
          elsif key == 'department_id' && a.department_id.present?
            row << Department.find(a.attributes.values_at(key)[0]).name
          elsif key == 'device_id' && a.device_id.present?
            row << Device.find(a.attributes.values_at(key)[0]).display_hostname_serial
          elsif key == 'notes'
            value = SensitiveDataSystem.find(record_id).notes.body
            row << Html2Text.convert(value)
          elsif key == 'tdx_tickets' && SensitiveDataSystem.find(record_id).tdx_tickets.present?
            tickets = ""
            SensitiveDataSystem.find(record_id).tdx_tickets.each do |ticket|
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
    "#{self.name} - #{self.id}"
  end

end
