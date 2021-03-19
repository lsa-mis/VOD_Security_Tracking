FactoryBot.define do
  factory :it_security_incident do
    date { "2021-03-19 17:25:18" }
    people_involved { "MyText" }
    equipment_involved { "MyText" }
    remediation_steps { "MyText" }
    estimated_finacial_cost { 1 }
    notes { "MyText" }
    it_security_incident_status { nil }
    data_type { nil }
  end
end
