# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)      not null
#  owner_full_name               :string(255)      not null
#  dept                          :string(255)
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)      not null
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  remediation                   :string(255)      not null
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)      not null
#  justification                 :string(255)
#  local_it_support_group        :string(255)
#  notes                         :text(65535)
#  data_type_id                  :bigint           not null
#  device_id                     :bigint
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#  incomplete                    :boolean          default(FALSE)
#
class LegacyOsRecord < ApplicationRecord
  belongs_to :data_type
  belongs_to :device
  has_many :tdx_tickets, as: :records_to_tdx
  accepts_nested_attributes_for :device

  has_many_attached :attachments
  audited

  validates :owner_username, presence: true
  validates :owner_full_name, presence: true
  validates :remediation, presence: true
  validates :review_contact, presence: true

  validate :validate_if_complete

  validate :unique_app_or_unique_hardware

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end
  
  def unique_app_or_unique_hardware
    if !self.incomplete
      errors.add(:unique_app, "or Unique Hardware needs a value") unless unique_app.present? || unique_hardware.present?
    end
  end

  def validate_if_complete
    if self.dept.blank?
      errors.add(:dept, "can't be blank") unless self.incomplete 
    end
    if self.phone.blank?
      errors.add(:phone, "can't be blank") unless self.incomplete 
    end
    if self.support_poc.blank?
      errors.add(:support_poc, "can't be blank") unless self.incomplete
    end
    if self.unique_date.blank?
      errors.add(:unique_date, "can't be blank") unless self.incomplete
    end

  end

end
