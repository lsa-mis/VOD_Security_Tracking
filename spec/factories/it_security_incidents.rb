# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  people_involved                :text(65535)      not null
#  equipment_involved             :text(65535)      not null
#  remediation_steps              :text(65535)      not null
#  estimated_finacial_cost        :integer
#  notes                          :text(65535)
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
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
