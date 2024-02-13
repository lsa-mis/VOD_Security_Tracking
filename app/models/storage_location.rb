# == Schema Information
#
# Table name: storage_locations
#
#  id                 :bigint           not null, primary key
#  name               :string(255)
#  description        :string(255)
#  description_link   :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  device_is_required :boolean          default(FALSE)
#
class StorageLocation < ApplicationRecord
  has_many :sensitive_data_systems
  audited

  validates :name, uniqueness: true, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["audits", "sensitive_data_systems"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "description_link", "device_is_required", "id", "name", "updated_at"]
  end
  
  def display_name
    if self.device_is_required
      "#{self.name} - device is required"
    else
      "#{self.name}"
    end
  end

end
