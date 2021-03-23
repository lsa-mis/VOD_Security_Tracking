# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  people_involved                :text(65535)
#  equipment_involved             :text(65535)
#  remediation_steps              :text(65535)
#  estimated_finacial_cost        :integer
#  notes                          :text(65535)
#  it_security_incident_status_id :bigint           not null
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
class ItSecurityIncident < ApplicationRecord
  belongs_to :it_security_incident_status
  belongs_to :data_type
  has_many :tdx_tickets, as: :records_to_tdx
  has_many_attached :attachments
  audited
end
