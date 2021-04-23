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
#  deleted_at                     :datetime
#
require 'rails_helper'

RSpec.describe ItSecurityIncident, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
