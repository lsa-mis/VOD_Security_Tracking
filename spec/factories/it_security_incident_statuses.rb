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
FactoryBot.define do
  factory :it_security_incident_status do
    name { Faker::String.random(length: 6..12) }
    description { Faker::String.random(length: 6..12) }
  end
end
