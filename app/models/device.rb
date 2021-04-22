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

    def display_name
        "#{self.serial} - #{self.hostname}" # or whatever column you want
      end
end
