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
    sequence(:name) { |n| "Incident Status #{n}" }
    description { Faker::Lorem.sentence(word_count: 4) }
  end
end
