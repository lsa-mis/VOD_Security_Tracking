# == Schema Information
#
# Table name: legacy_os_records
#
#  id                            :bigint           not null, primary key
#  owner_username                :string(255)
#  owner_full_name               :string(255)
#  dept                          :string(255)
#  phone                         :string(255)
#  additional_dept_contact       :string(255)
#  additional_dept_contact_phone :string(255)
#  support_poc                   :string(255)
#  legacy_os                     :string(255)
#  unique_app                    :string(255)
#  unique_hardware               :string(255)
#  unique_date                   :datetime
#  remediation                   :string(255)
#  exception_approval_date       :datetime
#  review_date                   :datetime
#  review_contact                :string(255)
#  justification                 :string(255)
#  local_it_support_group        :string(255)
#  notes                         :text(65535)
#  data_type_id                  :bigint           not null
#  device_id                     :bigint           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  deleted_at                    :datetime
#
class LegacyOsRecord < ApplicationRecord
  belongs_to :data_type
  belongs_to :device
  has_many :tdx_tickets, as: :records_to_tdx
  accepts_nested_attributes_for :device

  has_many_attached :attachments
  audited
  validates :owner_username, presence: true

  # validate :need_device
  # validates_associated :device

  scope :active, -> { where(deleted_at: nil) }
  scope :archived, -> { where("#{self.table_name}.deleted_at IS NOT NULL") }

  def archive
    self.update(deleted_at: DateTime.current)
  end

  def archived?
    self.deleted_at.present?
  end

  # def need_device
  #   serial = legacy_os_record_params[:device_attributes][:serial]
  #   logger.debug "******************************legacy_os_record_params: #{legacy_os_record_params}"

  #   logger.debug "******************************params: #{serial}"
  #   fail
  #   errors.add(:base, "Enter a device serial number") if self.device_attributes.serial.blank? 
  # end
  
end
