# == Schema Information
#
# Table name: data_types
#
#  id                           :bigint           not null, primary key
#  name                         :string(255)
#  description                  :string(255)
#  description_link             :string(255)
#  data_classification_level_id :bigint           not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#
class DataType < ApplicationRecord
  belongs_to :data_classification_level
  has_many :dpa_exceptions
  has_many :it_security_incidents
  has_many :legacy_os_records
  has_many :sensitive_data_systems
  audited

  validates :name, uniqueness: true, presence: true

  def display_name
    "#{self.name} - #{DataClassificationLevel.find(data_classification_level_id).name}"
  end
end
