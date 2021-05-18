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
#
class Device < ApplicationRecord
    has_many :sensitive_data_systems
    has_many :legacy_os_records
    audited

    # validates :serial, :hostname, uniqueness: true

    scope :incomplete, -> { Device.where("(serial = '' or serial IS NULL)  AND (mac is null or owner is null)").or(Device.where("(hostname = '' or hostname IS NULL)  AND (mac is null or owner is null)")) }

    def complete?
      if ((self.serial.blank? && (self.mac.blank? || self.owner.blank?)) || (self.hostname.blank? && (self.mac.blank? || self.owner.blank?)))
        false
      else 
        true
      end
    end

    def display_name
        "#{self.serial} - #{self.hostname}" # or whatever column you want
      end
end
