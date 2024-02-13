# == Schema Information
#
# Table name: departments
#
#  id               :bigint           not null, primary key
#  name             :string(255)
#  shortname        :string(255)
#  active_dir_group :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Department < ApplicationRecord
  has_many :legacy_os_records
  has_many :sensitive_data_systems
  has_many :dpa_exceptions

  validates :name, :shortname, uniqueness: true, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["dpa_exceptions", "legacy_os_records", "sensitive_data_systems"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["active_dir_group", "created_at", "id", "name", "shortname", "updated_at"]
  end
  
  def display_name
    "#{self.name}"
  end
end
