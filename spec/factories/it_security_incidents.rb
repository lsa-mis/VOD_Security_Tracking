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
    title { "Security Incident - #{Faker::Hacker.abbreviation}" }
    date { Faker::Date.backward(days: 30) }
    people_involved { Faker::Lorem.paragraph }
    equipment_involved { "#{Faker::Device.model_name} - #{Faker::Device.serial}" }
    remediation_steps { Faker::Lorem.paragraph }
    estimated_financial_cost { Faker::Number.between(from: 0, to: 100000) }
    association :it_security_incident_status
    association :data_type

    trait :with_notes do
      after(:build) do |incident|
        incident.notes = ActionText::RichText.new(body: Faker::Lorem.paragraph)
      end
    end

    trait :with_high_cost do
      estimated_financial_cost { Faker::Number.between(from: 100001, to: 1000000) }
    end

    trait :with_no_cost do
      estimated_financial_cost { nil }
    end

    trait :invalid_cost do
      estimated_financial_cost { "not a number" }
    end

    trait :invalid do
      title { nil }
    end
  end
end
