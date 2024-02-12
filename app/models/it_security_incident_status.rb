# == Schema Information
#
# Table name: it_security_incident_statuses
#
#  id          :bigint           not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ItSecurityIncidentStatus < ApplicationRecord
  has_many :it_security_incident

  validates :name, uniqueness: true, presence: true
  
  def self.ransackable_associations(auth_object = nil)
    ["it_security_incident"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "name", "updated_at"]
  end

end
