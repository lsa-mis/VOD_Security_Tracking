class ItSecurityIncident < ApplicationRecord
  belongs_to :it_security_incident_status
  belongs_to :data_type
end
