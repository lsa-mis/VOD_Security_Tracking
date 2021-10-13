# == Schema Information
#
# Table name: devices
#
#  id           :bigint           not null, primary key
#  serial       :string(255)
#  hostname     :string(255)
#  mac          :string(255)
#  building     :string(255)
#  room         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner        :string(255)
#  department   :string(255)
#  manufacturer :string(255)
#  model        :string(255)
#  deleted_at   :datetime
#
class Device < ApplicationRecord
  has_many :sensitive_data_systems
  has_many :legacy_os_records
  before_destroy :no_referenced_records

  audited

  validates :serial, :hostname, uniqueness: true, allow_blank: true
  validate :serial_or_hostname

  scope :incomplete, -> { Device.where("(serial = '' or serial IS NULL)  AND (mac is null or mac = '' or owner is null or owner = '')").or(Device.where("(hostname = '' or hostname IS NULL)  AND (mac is null or mac = '' or owner is null or owner = '')")) }

  def serial_or_hostname
    errors.add(:serial, "or hostname needs a value") unless serial.present? || hostname.present?
  end

  def complete?
    if ((self.serial.blank? && (self.mac.blank? || self.owner.blank?)) || (self.hostname.blank? && (self.mac.blank? || self.owner.blank?)))
      false
    else 
      true
    end
  end

  def display_name
    if self.hostname.present?
      "#{self.hostname}" # or whatever column you want
    else 
      "#{self.serial}"
    end
  end

  def display_hostname_serial
    if self.hostname.present?
      name = "#{self.hostname} " # or whatever column you want
    else
      name = "none "
    end
    if self.serial.present?
      name += "#{self.serial}"
    else 
      name += "none"
    end
    name
  end

  def display_hostname
    "#{self.hostname}" # or whatever column you want
  end

  def no_referenced_records
    if LegacyOsRecord.find_by(device_id: self)
      errors.add(:base, "Can't destroy this device")
      throw :abort 
    elsif SensitiveDataSystem.find_by(device_id: self)
      errors.add(:base, "Can't destroy this device")
      throw :abort 
    else
      return true
    end
  end
end
