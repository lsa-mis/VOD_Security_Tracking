# == Schema Information
#
# Table name: sensitive_data_systems
#
#  id                                  :bigint           not null, primary key
#  owner_username                      :string(255)      not null
#  owner_full_name                     :string(255)      not null
#  dept                                :string(255)
#  phone                               :string(255)
#  additional_dept_contact             :string(255)
#  additional_dept_contact_phone       :string(255)
#  support_poc                         :string(255)
#  expected_duration_of_data_retention :text(65535)
#  agreements_related_to_data_types    :string(255)
#  review_date                         :datetime
#  review_contact                      :string(255)
#  notes                               :text(65535)
#  storage_location_id                 :bigint
#  data_type_id                        :bigint
#  device_id                           :bigint
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  deleted_at                          :datetime
#  incomplete                          :boolean          default(FALSE)
#  name                                :string(255)      not null
#
class SensitiveDataSystem < ApplicationRecord
  belongs_to :storage_location, optional: true
  belongs_to :data_type, optional: true
  belongs_to :device, optional: true
  has_many :tdx_tickets, as: :records_to_tdx
  accepts_nested_attributes_for :device

  has_many_attached :attachments
  before_save :if_not_complete

  audited

  validates :owner_username, :owner_full_name, :dept, presence: true
  validate :acceptable_attachments

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
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
        errors.add(:attachments, "must be an acceptable file type")
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
    not_completed = self.attributes.except("id", "created_at", "updated_at", "deleted_at", "incomplete", "device_id").all? {|k, v| v.present?} ? false : true
    if not_completed
      if self.storage_location_id.present?
        not_completed = false unless StorageLocation.find(self.storage_location_id).device_is_required && self.device_id.present?
      end
    end
    return not_completed
  end

  def display_name
    "#{self.name} - #{self.id}"
  end

end
