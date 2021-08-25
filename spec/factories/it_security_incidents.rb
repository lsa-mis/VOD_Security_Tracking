# == Schema Information
#
# Table name: it_security_incidents
#
#  id                             :bigint           not null, primary key
#  date                           :datetime
#  estimated_financial_cost       :integer
#  it_security_incident_status_id :bigint
#  data_type_id                   :bigint           not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  deleted_at                     :datetime
#  incomplete                     :boolean          default(FALSE)
#  title                          :string(255)      not null
#
FactoryBot.define do
  factory :it_security_incident do
    title { Faker::String.random(length: 10..20) }
    date { Faker::Date.in_date_period }
    people_involved { Faker::String.random(length: 20..120) }
    equipment_involved { Faker::String.random(length: 20..120) }
    remediation_steps { Faker::String.random(length: 20..120) }
    estimated_financial_cost { Faker::Number.decimal(l_digits: 2) }
    notes { Faker::String.random(length: 20..120) }
    it_security_incident_status
    data_type
  end
end
