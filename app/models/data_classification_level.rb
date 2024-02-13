# == Schema Information
#
# Table name: data_classification_levels
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class DataClassificationLevel < ApplicationRecord
  has_many :data_types
  audited

  validates :name, uniqueness: true, presence: true
  
  def self.ransackable_associations(auth_object = nil)
    ["audits", "data_types"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end
end
