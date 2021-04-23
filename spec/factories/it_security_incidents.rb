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
FactoryBot.define do
  factory :it_security_incident do
    date { "2021-03-19 17:42:48" }
    people_involved { "MyText" }
    equipment_involved { "MyText" }
    remediation_steps { "MyText" }
    estimated_finacial_cost { 1 }
    notes { "MyText" }
    it_security_incident_status { nil }
    data_type { nil }
  end
end
